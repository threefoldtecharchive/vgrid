module gridproxy

import despiegk.crystallib.redisclient
import net.http
import json
import despiegk.crystallib.crystaljson


pub enum GridproxyStatus {
	init
	ok
	error
}



pub struct GridproxyConnection {
pub mut:
	redis         	redisclient.Redis
	status		 	GridproxyStatus
	url 			string
	cache_timeout 	int = 3600
	cache 			bool = true
}


pub enum TFGridNet{
	main
	test
	dev
}

[heap]
struct GridproxyFactory {
mut:
	instances    map[string]&GridproxyConnection
}

fn init_factory() GridproxyFactory {
	mut ef := GridproxyFactory{}
	return ef
}


// Singleton creation
const factory = init_factory()

fn factory_get() &GridproxyFactory{
	return &factory
} 



fn gridproxy_url_get(net TFGridNet) string{
	return match net {
		.main { 'https://gridproxy.grid.tf' }
		.test { 'https://gridproxy.test.grid.tf' } 
		.dev { 'https://gridproxy.dev.grid.tf' }
	}	
}

//return which net in string form
fn  tfgrid_net_string(net TFGridNet) string {	
	return match net {
		.main { 'main' }
		.test { 'test' } 
		.dev { 'def' }
	}	
}


pub fn get(net TFGridNet) &GridproxyConnection {
	mut f := factory_get()
	netstr := tfgrid_net_string(net)
	if ! (netstr in factory.instances){
		url := gridproxy_url_get(net)
		mut connection := GridproxyConnection{
				redis: redisclient.connect('127.0.0.1:6379') or { redisclient.Redis{} }
				url: url
			}
		f.instances[netstr] = &connection
	}
	return f.instances[netstr]
}


fn (mut h GridproxyConnection) header() http.Header {
	/*
	Create a new header for Content type and Authorization

	Output:
		header: http.Header with the needed headers
	*/
	mut header := http.new_header_from_map({
		http.CommonHeader.content_type:  'application/json'
	})
	return header
}


fn (mut h GridproxyConnection) get_json_list(prefix string, cache bool) ?[]string {
	/*
	Get Request with Json Data
	Inputs:
		data: Json encoded data.
		cache: Flag to enable caching.

	Output:
		response: list of strings.
	*/
	mut result := h.get_json_str(prefix, cache) ?
	return crystaljson.json_list(result, false)
}

// Get request with json data and return response as string
fn (mut h GridproxyConnection) get_json_str(prefix string,cache bool) ?string {
	/*
	Get Request with Json Data
	Inputs:
		prefix: Gridproxy elements types, ex (projects, issues, tasks, ...).
		data: Json encoded data.
		cache: Flag to enable caching.

	Output:
		response: response as string.
	*/
	getdata := ""
	mut result := h.cache_get(prefix, getdata, cache)
	if result == '' {
		url := '$h.url/$prefix'
		mut req := http.new_request(http.Method.get, url, getdata) ?
		req.header = h.header()
		req.add_custom_header('x-disable-pagination', 'True') ?
		res := req.do() ?
		if res.status_code == 200 {
			result = res.text
		} else {
			return error('could not get: $url\n$res')
		}
		h.cache_set(prefix, getdata, result, cache) ?
	}
	return result
}
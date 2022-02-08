module explorer

import despiegk.crystallib.redisclient
import net.http
import json
import crypto.md5

pub enum ExplorerStatus {
	init
	ok
	error
}



pub struct ExplorerConnection {
pub mut:
	redis         	redisclient.Redis
	status		 	ExplorerStatus
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
struct ExplorerFactory {
mut:
	instances    map[string]&ExplorerConnection
}

fn init_factory() ExplorerFactory {
	mut ef := ExplorerFactory{}
	return ef
}


// Singleton creation
const factory = init_factory()

fn factory_get() &ExplorerFactory{
	return &factory
} 



fn explorer_url_get(net TFGridNet) string{
	return match net {
		.main { 'https://graphql.grid.tf/graphql' }
		.test { 'https://graphql.test.grid.tf/graphql' } 
		.dev { 'https://graphql.dev.grid.tf/graphql' }
	}	
}

//return which net in string form
fn  tfgrid_net_string(net TFGridNet) string {	
	return match net {
		.main { 'main' }
		.test { 'test' } 
		.dev { 'dev' }
	}	
}


//main method to get connection to the explorer connection based on tfgridnet: .main, .test, .dev
//
// do following:
//
// 		import threefoldtech.vgrid.explorer
// 		mut explorer := explorer.get(.test) ?
//
pub fn get(net TFGridNet) &ExplorerConnection {
	mut f := factory_get()
	netstr := tfgrid_net_string(net)
	if ! (netstr in factory.instances){
		url := explorer_url_get(net)
		mut expl := ExplorerConnection{
				redis: redisclient.connect('127.0.0.1:6379') or { redisclient.Redis{} }
				url: url
			}
		f.instances[netstr] = &expl
	}
	return f.instances[netstr]
}





struct GraphqlQuery {
mut:
	query     		string
	operation 		string
}

struct ReqData {
	data Body
}

struct Body {
	entities  []TFGridEntity
	twins     []TFGridTwin
	nodes     []TFGridNode
	farms     []TFGridFarmer
	countries []Country
	cities    []City
}

pub fn make_post_request_query(url string, query GraphqlQuery) ?http.Request {
	post := http.method_from_str('POST')
	data := json.encode(query)
	mut req := http.new_request(post, url, data) ?
	req.add_header(http.CommonHeader.content_type, 'application/json')
	return req
}

//query the graphql layer with caching
fn (mut explorer ExplorerConnection) query(query GraphqlQuery) ?ReqData {

	cachekey := md5.hexhash(query.query)

	cached_data := explorer.cache_get(query.operation, cachekey, explorer.cache)
	if cached_data.len > 0 {
		// println("*****CACHE HIT*****")
		data2 := json.decode(ReqData, cached_data) or {
			return error('failed to decode json from cache, BUG.\n$err\n$query')
		}		
		return data2
	}	

	req := make_post_request_query(explorer.url, query) ?
	res := req.do() ?

	if ! (res.status_code == 200){
		return error('could not get: $query\n$res')
	}

	data := json.decode(ReqData, res.text) or {
		return error('failed to decode json.\n$err\n$query')
	}
	explorer.cache_set(query.operation, cachekey, res.text, explorer.cache) ?
	return data

}

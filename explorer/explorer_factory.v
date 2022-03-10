module explorer

import despiegk.crystallib.httpconnection
import net.http
import json
// import crypto.md5

pub enum ExplorerStatus {
	init
	ok
	error
}



pub struct ExplorerConnection {
pub mut:
	http	&httpconnection.HTTPConnection
	tfgridnet TFGridNet
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

// return always new explorer to be used in threads
pub fn new (net TFGridNet) &ExplorerConnection {
	netstr := tfgrid_net_string(net)
	url := explorer_url_get(net)
	mut httpconn_new := false
	// ensure that this explorer have new client of redis for its httpconnection
	mut httpconn := httpconnection.get("explorer_${netstr}") or {
		httpconn_new = true
		httpconnection.new("explorer_${netstr}",url,true)
	}
	if !httpconn_new {
		httpconn = httpconn.clone()
	}
	//do the settings on the connection
	httpconn.cache.expire_after = 7200 //make the cache timeout 2h
	httpconn.cache.allowable_methods << .post
	return &ExplorerConnection{http: httpconn, tfgridnet: net}
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
		mut httpconn := httpconnection.new("explorer_${netstr}",url,true)
		//do the settings on the connection
		httpconn.cache.expire_after = 7200 //make the cache timeout 2h
		httpconn.cache.allowable_methods << .post
		mut expl := ExplorerConnection{http: httpconn,tfgridnet: net}
		f.instances[netstr] = &expl
	}
	return f.instances[netstr]
}





struct GraphqlQuery {
mut:
	query     		string
	operation 		string
	cache           bool = true
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

//query the graphql layer with caching
fn (mut explorer ExplorerConnection) query(query GraphqlQuery) ?ReqData {

	postdata := json.encode(query)
	mut cache_disable:=false
	if query.cache==false{
		cache_disable=true
	}
	result := explorer.http.post_json_str(mut prefix:"", data: postdata, cache_disable: cache_disable)?

	data := json.decode(ReqData,result) or {
		println("=======\n$result\n=========")
		return error('failed to decode json.\n$err\n$query')
	}
	return data
}
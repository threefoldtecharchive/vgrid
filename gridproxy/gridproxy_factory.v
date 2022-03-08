module gridproxy

import despiegk.crystallib.httpconnection

pub enum GridproxyStatus {
	init
	ok
	error
}



pub struct GridproxyConnection {
pub mut:
	status		 	GridproxyStatus
	http	httpconnection.HTTPConnection
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
		.dev { 'dev' }
	}	
}


pub fn get(net TFGridNet) &GridproxyConnection {
	mut f := factory_get()
	netstr := tfgrid_net_string(net)
	if ! (netstr in factory.instances){
		url := gridproxy_url_get(net)
		mut httpconn := httpconnection.new("gridproxy_${netstr}",url,true)
		//do the settings on the connection
		httpconn.cache.expire_after = 7200 //make the cache timeout 2h
		mut connection:=GridproxyConnection{
			http:httpconn
		}
		f.instances[netstr] = &connection
	}
	return f.instances[netstr]
}


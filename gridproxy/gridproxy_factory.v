module gridproxy

import despiegk.crystallib.httpconnection

pub struct GridproxyClient {
pub mut:
	http_client httpconnection.HTTPConnection
}

pub enum TFGridNet {
	main
	test
	dev
	qa
}

[heap]
struct GridproxyFactory {
mut:
	instances map[string]&GridproxyClient
}

fn init_factory() GridproxyFactory {
	mut ef := GridproxyFactory{}
	return ef
}

// Singleton creation
const factory = init_factory()

fn factory_get() &GridproxyFactory {
	return &gridproxy.factory
}

fn gridproxy_url_get(net TFGridNet) string {
	return match net {
		.main { 'https://gridproxy.grid.tf' }
		.test { 'https://gridproxy.test.grid.tf' }
		.dev { 'https://gridproxy.dev.grid.tf' }
		.qa { 'https://gridproxy.qa.grid.tf/' }
	}
}

// return which net in string form
fn tfgrid_net_string(net TFGridNet) string {
	return match net {
		.main { 'main' }
		.test { 'test' }
		.dev { 'dev' }
		.qa { 'qa' }
	}
}

pub fn get(net TFGridNet, use_redis_cache bool) &GridproxyClient {
	mut f := factory_get()
	netstr := tfgrid_net_string(net)
	if netstr !in gridproxy.factory.instances {
		url := gridproxy_url_get(net)
		mut httpconn := httpconnection.new('gridproxy_$netstr', url, use_redis_cache)
		// do the settings on the connection
		httpconn.cache.expire_after = 7200 // make the cache timeout 2h
		mut connection := GridproxyClient{
			http_client: httpconn
		}
		f.instances[netstr] = &connection
	}
	return f.instances[netstr]
}

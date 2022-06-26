module explorer

import sync.pool
import threefoldtech.vgrid.gridproxy
import despiegk.crystallib.texttools

struct SRequest {
	nodeid int
mut:
	gp &gridproxy.GridproxyConnection
}

struct SResult {
    info gridproxy.NodeInfo
}

fn sprocess(pp &pool.PoolProcessor, idx int, wid int) &SResult {
    mut item := pp.get_item<SRequest>(idx)
	info := item.gp.node_info(item.nodeid) or { panic(err) }

	return &SResult{info: info}
}


//get all nodes from explorer, will use a threadpool to fetchall if not in queue yet
pub fn (mut e ExplorerConnection) get_nodes(cache_reset bool) ?[]gridproxy.NodeInfo {
	net2 := match e.tfgridnet {
		.main { gridproxy.TFGridNet.main }
		.test { gridproxy.TFGridNet.test }
		.dev { gridproxy.TFGridNet.dev }
	}

	mut gp := gridproxy.get(net2)

	mut res := []gridproxy.NodeInfo{}

	mut farms_dict := map[int]TFGridFarmer{}
	farms := e.farms_list()?
	for farm in farms{
		farms_dict[int(farm.id)]=farm
	}


	if cache_reset{
		println( " - fetching nodes from explorer, empty cache ")
		e.http.cache_drop()?
		gp.http.cache_drop()?
	}

	// mut r := explorer.twin_list()?
	mut r := e.nodes_list()?
	mut nodes_dict := map[int]TFGridNode{}

	mut pp := pool.new_pool_processor(callback: sprocess)
	mut nodesreq := []SRequest{}

	for item in r {
		nodesreq << SRequest{gp: gp, nodeid: int(item.id)}
		nodes_dict[int(item.id)] = item
	}

	println("fetching $nodesreq.len nodes info")
	pp.work_on_items(nodesreq)

	for item in pp.get_results<SResult>() {
		mut node_info := item.info

		n := nodes_dict[int(node_info.id)]
		node_info.longitude = n.location.longitude.f32()
		node_info.latitude = n.location.latitude.f32()
		node_info.country = texttools.name_fix(n.country)
		node_info.city = texttools.name_fix(n.city)
		node_info.farm_id = n.farm_id
		if int(n.farm_id) in farms_dict{
			farm2:= farms_dict[int(n.farm_id)]
			node_info.farm = texttools.name_fix(farm2.name)
		}else{
			node_info.farm = "error:farm unknown"
		}

		node_info.nr_pub_ipv4 = n.public_config.ipv4.int()
		if ! node_info.iserror{
			res << node_info
		}
	}

	return res

}

pub fn (mut e ExplorerConnection) gridproxy() &gridproxy.GridproxyConnection {

	net2 := match e.tfgridnet {
		.main { gridproxy.TFGridNet.main }
		.test { gridproxy.TFGridNet.test } 
		.dev { gridproxy.TFGridNet.dev }
	}	

	mut gp := gridproxy.get(net2)

	return gp
	
}

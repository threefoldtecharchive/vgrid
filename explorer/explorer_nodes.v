module explorer

import threefoldtech.vgrid.gridproxy
import despiegk.crystallib.texttools

//get all nodes from explorer, will use a threadpool to fetchall if not in queue yet
pub fn (mut e ExplorerConnection) get_nodes(cache_reset bool) ?[]gridproxy.NodeInfo {

	net2 := match e.tfgridnet {
		.main { gridproxy.TFGridNet.main }
		.test { gridproxy.TFGridNet.main } 
		.dev { gridproxy.TFGridNet.main }
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
		e.http.cache_drop("")?
		gp.http.cache_drop("")?
	}

	// mut r := explorer.twin_list()?
	mut r := e.nodes_list()?
	mut threads := []thread ?gridproxy.NodeInfo {}
	mut nodes_dict := map[int]TFGridNode{}
	for item in r {
		// println(item.id)
		threads << go gp.node_info(int(item.id))
		nodes_dict[int(item.id)]=item
		// println(item)
		// gp.node_info(int(item.id))?
	}
	println("threads wait")
	for item in threads{
		mut node_info := item.wait() or {
			println("error in getting info for node.\n$err")
			continue
		}
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
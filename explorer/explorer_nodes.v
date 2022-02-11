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
	
	if cache_reset{
		println( " - fetching nodes from explorer, empty cache ")
		e.http.cache_drop("")?
		gp.http.cache_drop("")?
	}

	// mut r := explorer.twin_list()?
	mut r := e.nodes_list()?
	mut threads := []thread ?gridproxy.NodeInfo {}
	mut nodes_dict := map[u32]TFGridNode{}
	for item in r {
		// println(item.id)
		threads << go gp.node_info(item.id)
		nodes_dict[item.id]=item
		// println(item)
		// gp.node_info(int(item.id))?
	}
	// println("threads wait")
	for item in threads{
		mut node_info := item.wait() or {
			print("error in getting info for node")
			continue
		}
		n := nodes_dict[node_info.id]
		node_info.longitude = n.location.longitude.f32()
		node_info.latitude = n.location.latitude.f32()
		node_info.country = texttools.name_fix(n.country)
		node_info.city = texttools.name_fix(n.city)
		node_info.nr_pub_ipv4 = n.public_config.ipv4.int()
		if ! node_info.iserror{
			res << node_info
		}
	}

	return res

}
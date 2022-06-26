import threefoldtech.vgrid.gridproxy
import threefoldtech.vgrid.gridproxy.model {ResourcesFilter}
import os


fn main(){
	//Default value used in intializing the resources
	mut resources_filter := ResourcesFilter {}

	if "--help" in os.args {
		println("This method to get nodes by city or country or both \n
		--sru 		nodes selected should have a minumum value of free sru in GB (ssd resource unit) equal to this  (optional) \n
		--hru 		nodes selected should have a minumum value of free hru in GB (hd resource unit) equal to this  (optional) \n
		--mru   	nodes selected should have a minumum value of free mru in GB (memory resource unit) equal to this (optional) \n
		--ips 		nodes selected should have a minumum value of ips (ips in the farm of the node) equal to this  (optional)")
		return
	}

	if "--sru" in os.args {
		index_val := os.args.index("--sru")
		resources_filter.free_sru_gb = os.args[index_val+1].u64()
	}

	if "--ips" in os.args {
		index_val := os.args.index("--ips")
		resources_filter.free_ips = os.args[index_val+1].u64()
	}

	if "--hru" in os.args {
		index_val := os.args.index("--hru")
		resources_filter.free_hru_gb = os.args[index_val+1].u64()
	}

	if "--mru" in os.args {
		index_val := os.args.index("--mru")
		resources_filter.free_mru_gb = os.args[index_val+1].u64()
	}

	mut gp_client := gridproxy.get(.test, false)
	nodes_with_min_resources := gp_client.get_nodes_has_resources(resources_filter) or {
		println("got an error while getting nodes")
		println("error message : ${err.msg()}")
		println("error code : ${err.code()}")
		return
	}
	println("found $nodes_with_min_resources.len nodes with following min resources:\n$resources_filter")
	println("---------------------------------------")
	println(nodes_with_min_resources)
}

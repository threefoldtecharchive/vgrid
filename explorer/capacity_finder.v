module explorer


pub struct LocationArgs {
pub:
	//min GB of memory in node
	mem_min_gb		int
	//min nr of virtual cores 
	cpu_min_vcore	int
	//min nr of GB in SSD
	ssd_min_gb		int
	//min nr of GB in HDD
	hdd_min_gb		int
	//min % free of machine for mem
	mem_min_free_perc		int
	//min % free of machine for cput
	cpu_min_free_perc	int
	//min % free of machine for SSD storage capacity
	ssd_min_free_perc		int
	//min % free of machine for HDD storage capacity
	hdd_min_free_perc		int	
	//is there public ip attached to the node
	public_ip 		bool
	//you can force the node id
	nodeid			int
	//if we want to use the cache, default is on true
	cache    		bool = true
}



//execute terraform
fn (mut explorer ExplorerConnection) node_find(args LocationArgs) ? {
	// mut tfgrid := explorer.tfgrid_new() ?
	// mut nodes_by_capacity := tfgrid.nodes_list_by_resource(sru, cru, hru, mru)?

}

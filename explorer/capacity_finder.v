module explorer
import threefoldtech.vgrid.gridproxy
import freeflowuniverse.crystallib.texttools
import rand

pub enum Region {
	world
	europe_west
}

pub struct NodeFinderArgs {
pub:
	//min GB of memory in node
	mem_min_gb				f32
	//min nr of virtual cores 
	cpu_min_vcore			int
	//min nr of GB in SSD
	ssd_min_gb				int
	//min nr of GB in HDD
	hdd_min_gb				int
	//min % free of machine for mem
	mem_min_free_perc		int
	//min % free of machine for cput
	cpu_min_free_perc		int
	//min % free of machine for SSD storage capacity
	ssd_min_free_perc		int
	//min % free of machine for HDD storage capacity
	hdd_min_free_perc		int	
	//is there public ip attached to the node
	public_ip 				bool
	//you can force the node id
	nodeid					int
	//if we want to use the cache, default is on true
	cache    				bool = true
	country      			string
	region 					Region
}


// cru int
// sru int
// hru int
// mru int
// //nr of public ip addresses available for the node
// nr_pub_ipv4 int


pub fn (mut explorer ExplorerConnection) node_find(args NodeFinderArgs) ?gridproxy.NodeInfo {

	nodes := explorer.nodes_find(args)?

	if nodes.len==0{
		return error("Could not find node with findargs:\n $args")
	}

	c := rand.int_in_range(0,nodes.len-1) or { 
		return error("Couldn't generate rand number with error: $err")
	}
	return nodes[c]

}

pub fn (mut explorer ExplorerConnection) nodes_find(args NodeFinderArgs) ?[]gridproxy.NodeInfo {
	ns := explorer.get_nodes(false)?
	mut res := []gridproxy.NodeInfo{}
	for tocheck in [
		args.mem_min_free_perc,
		args.cpu_min_free_perc,
		args.ssd_min_free_perc,
		args.hdd_min_free_perc,
	] {
		if tocheck>100{
			return error("the min perc nee to be >0 and =< 100")
		}
	}
	for node in ns{

		cru_available_gb := node.available_resources.cru - node.used_resources.cru
		mru_available_gb := node.available_resources.mru - node.used_resources.mru
		hru_available_gb := node.available_resources.hru - node.used_resources.hru
		sru_available_gb := node.available_resources.sru - node.used_resources.sru

		if args.mem_min_gb>mru_available_gb{
			continue
		}
		if args.cpu_min_vcore>cru_available_gb{
			continue
		}
		if args.ssd_min_gb>sru_available_gb{
			continue
		}
		if args.hdd_min_gb>hru_available_gb{
			continue
		}

		if args.public_ip{
			if node.nr_pub_ipv4 == 0{
				continue
			}
		}

		if args.region != .world{
			//means there was a region specified
			region2:=regionmatch(longitude:node.longitude,latitude:node.latitude)
			// println(" = $node.country:$region2")
			if args.region != region2{
				continue
			}

		}

		if args.country!=""{
			country := texttools.name_fix(args.country)
			if node.country != country{
				continue
			}
		}

		if args.mem_min_free_perc>0{
			mem_free := int((node.used_resources.mru / node.available_resources.mru)*100)
			if args.mem_min_free_perc > mem_free{
				continue
			}
		}
		
		if args.cpu_min_free_perc>0{
			cpu_free := int((node.used_resources.cru / node.available_resources.cru)*100)
			if args.cpu_min_free_perc > cpu_free{
				continue
			}
		}

		if args.ssd_min_free_perc>0{
			ssd_free := int((node.used_resources.sru / node.available_resources.sru)*100)
			if args.ssd_min_free_perc > ssd_free{
				continue
			}
		}

		if args.hdd_min_free_perc>0{
			hdd_free := int((node.used_resources.hru / node.available_resources.hru)*100)
			if args.hdd_min_free_perc > hdd_free{
				continue
			}
		}

		res << node

	}
	
	return res
}

struct RegionArgs{
	latitude f32
	longitude f32
}

pub fn regionmatch(region RegionArgs) Region{
	// println(region)
	if region.longitude>-10 && region.longitude<20 && region.latitude>35 && region.latitude<60{
		return Region.europe_west
	}
	return Region.world
}

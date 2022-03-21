module gridproxy
import json

//RAW JSON FROM SERVER
struct NodeInfo_{
	capacity NodeCapacity_
}

struct NodeCapacity_{
	total_resources NodeResources_
	used_resources NodeResources_
}

struct NodeResources_{
	cru int
	sru u64
	hru u64
	mru u64
	ipv4u int
}

//CLEAN OBJECT
pub struct NodeInfo{
pub mut:
	id 				int
	available_resources NodeResources
	used_resources NodeResources
	nr_pub_ipv4 	int
	longitude 		f32
	latitude 		f32
	country 		string
	city 			string	
	iserror			bool
	farm_id			u32
	farm 			string
}

pub struct NodeResources{
pub:
	//all in GB
	cru int
	sru int
	hru int
	mru f32
	//nr of public ip addresses available for the node
}


//returns true,NodeInfo if it succeeded, otherwise false...
pub fn (mut h GridproxyConnection) node_info(nodeid int) ?NodeInfo {

	//needed to allow to use threads
	mut http := h.http.clone()

	data := http.get_json_str(mut prefix:"nodes/", id: "$nodeid") or {
		if err.str().contains("error fetching node capacity"){
			return NodeInfo{iserror:true}
		}
		panic(err)
	}
	r := json.decode(NodeInfo_, data) or {
		return error("error to get jsonstr for node_info, json decode: node: $nodeid")
	}
	mut ni := NodeInfo{
		id: nodeid
		available_resources:NodeResources{
			cru: r.capacity.total_resources.cru
			sru: int((r.capacity.total_resources.sru/1000000000))
			hru: int((r.capacity.total_resources.hru/1000000000))
			mru: f32((r.capacity.total_resources.mru/1000000000))
			// nr_pub_ipv4: r.capacity.total_resources.ipv4u
		},
		used_resources:NodeResources{
			cru: r.capacity.used_resources.cru
			sru: int((r.capacity.used_resources.sru/1000000000))
			hru: int((r.capacity.used_resources.hru/1000000000))
			mru: f32((r.capacity.used_resources.mru/1000000000))
			// nr_pub_ipv4: r.capacity.used_resources.ipv4u
		}
	}

	return ni
}



pub fn (mut h GridproxyConnection) nodes_print(nodes []NodeInfo) string {
	mut res := []string{}
	res <<"\n\nAVAILABLE NODES (MEM in GB, SSD/HDD in TB):\n-------------------------------------------\n"
	for node in nodes{
		cru_available_gb := node.available_resources.cru - node.used_resources.cru
		mru_available_gb := node.available_resources.mru - node.used_resources.mru
		hru_available_gb := node.available_resources.hru - node.used_resources.hru
		sru_available_gb := node.available_resources.sru - node.used_resources.sru		
		res << "${node.id:-5} ${node.country:-15}${node.farm.limit(30):-31} pubip:${node.nr_pub_ipv4:-5} ${cru_available_gb:4} cores | ${mru_available_gb:4} mem | ${(f32(sru_available_gb)/1000):5.1} ssd | ${(hru_available_gb)/1000:5} hdd"
	}
	res <<"\n"
	return res.join_lines()
}

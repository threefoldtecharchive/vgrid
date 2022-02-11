module gridproxy
import json

//RAW JSON FROM SERVER
struct NodeInfo_{
	capacity NodeCapacity_
}

struct NodeCapacity_{
	total_resources NoteResources_
	used_resources NoteResources_
}

struct NoteResources_{
	cru int
	sru u64
	hru u64
	mru u64
	ipv4u int
}

//CLEAN OBJECT
pub struct NodeInfo{
pub mut:
	id 				u32
	available_resources NodeResources
	used_resources NodeResources
	nr_pub_ipv4 	int
	longitude 		f32
	latitude 		f32
	country 		string
	city 			string	
	iserror			bool
}

pub struct NodeResources{
pub:
	//all in GB
	cru int
	sru int
	hru int
	mru int
	//nr of public ip addresses available for the node
}


//returns true,NodeInfo if it succeeded, otherwise false...
pub fn (mut h GridproxyConnection) node_info(nodeid u32) ?NodeInfo {

	//needed to allow to use threads
	mut http := h.http.clone()?

	data := http.get_json_str(mut prefix:"nodes/$nodeid") or {
		return NodeInfo{iserror:true}
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
			mru: int((r.capacity.total_resources.mru/1000000000))
			// nr_pub_ipv4: r.capacity.total_resources.ipv4u
		},
		used_resources:NodeResources{
			cru: r.capacity.used_resources.cru
			sru: int((r.capacity.used_resources.sru/1000000000))
			hru: int((r.capacity.used_resources.hru/1000000000))
			mru: int((r.capacity.used_resources.mru/1000000000))
			// nr_pub_ipv4: r.capacity.used_resources.ipv4u
		}
	}

	return ni
}
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
pub:
	available_resources NoteResources
	used_resources NoteResources
}

pub struct NoteResources{
pub:
	//all in GB
	cru int
	sru int
	hru int
	mru int
	//nr of public ip addresses available for the node
	nr_pub_ipv4 int
}



pub fn (mut h GridproxyConnection) node_info(nodeid int) ?NodeInfo {
	data := h.get_json_str("/nodes/$nodeid",true)?
	r := json.decode(NodeInfo_, data) ?
	ni := NodeInfo{
		available_resources:NoteResources{
			cru: r.capacity.total_resources.cru
			sru: int((r.capacity.total_resources.sru/1000000000))
			hru: int((r.capacity.total_resources.hru/1000000000))
			mru: int((r.capacity.total_resources.mru/1000000000))
			nr_pub_ipv4: r.capacity.total_resources.ipv4u
		},
		used_resources:NoteResources{
			cru: r.capacity.used_resources.cru
			sru: int((r.capacity.used_resources.sru/1000000000))
			hru: int((r.capacity.used_resources.hru/1000000000))
			mru: int((r.capacity.used_resources.mru/1000000000))
			nr_pub_ipv4: r.capacity.used_resources.ipv4u
		}
	}
	return ni
}
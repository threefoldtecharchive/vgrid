module model

import json

struct NodeResources {
pub:
	cru i64
	mru ByteUnit
	sru ByteUnit
	hru ByteUnit
}

struct NodeCapacity {
pub:
	total_resources NodeResources
	used_resources  NodeResources
}

struct NodeLocation {
pub:
	country string
	city    string
}

struct PublicConfig {
pub:
	domain string
	gw4    string
	gw6    string
	ipv4   string
	ipv6   string
}

pub struct Node {
pub:
	id                string
	node_id           i64          [json: nodeId]
	farm_id           i64          [json: farmId]
	twin_id           i64          [json: twinId]
	grid_version      i64          [json: gridVersion]
	uptime            SecondUnit
	created           UnixTime     [json: created]
	farming_policy_id i64          [json: farmingPolicyId]
	updated_at        UnixTime     [json: updatedAt]
	capacity          NodeCapacity
	location          NodeLocation
	public_config     PublicConfig [json: publicConfig]
	certification     string       [json: certificationType]
	status            string
	dedicated         bool
	rent_contract_id  i64          [json: rentContractId]
	rented_by_twin_id i64          [json: rentedByTwinId]
}

pub fn (n &Node) calc_available_resources() NodeResources {
	total_resources := n.capacity.total_resources
	used_resources := n.capacity.used_resources
	return NodeResources{
		cru: total_resources.cru - used_resources.cru
		mru: total_resources.mru - used_resources.mru
		sru: total_resources.sru - used_resources.sru
		hru: total_resources.hru - used_resources.hru
	}
}

pub fn (n &Node) is_online() bool {
	return n.status == 'up'
}

[params]
pub struct NodesParams {
pub:
	page          i64 | EmptyOption = EmptyOption{}
	size          i64 | EmptyOption = EmptyOption{}
	ret_count     i64 | EmptyOption = EmptyOption{}
	free_mru      i64 | EmptyOption = EmptyOption{}
	free_sru      i64 | EmptyOption = EmptyOption{}
	free_hru      i64 | EmptyOption = EmptyOption{}
	free_ips      i64 | EmptyOption = EmptyOption{}
	city          string
	country       string
	farm_name     string
	ipv4          string
	ipv6          string
	domain        string
	status 		  string
	dedicated     bool | EmptyOption = EmptyOption{}
	rentable      bool | EmptyOption = EmptyOption{}
	rented_by     i64 | EmptyOption  = EmptyOption{}
	available_for i64 | EmptyOption  = EmptyOption{}
	farm_ids      []i64
}

// serialize NodesParams to map
pub fn (p &NodesParams) to_map() map[string]string {
	mut m := map[string]string{}
	match p.page {
		EmptyOption {}
		i64 {
			m['pages'] = p.page.str()
		}
	}
	match p.size {
		EmptyOption {}
		i64 {
			m['size'] = p.size.str()
		}
	}
	match p.ret_count {
		EmptyOption {}
		i64 {
			m['ret_count'] = p.ret_count.str()
		}
	}
	match p.free_mru {
		EmptyOption {}
		i64 {
			m['free_mru'] = p.free_mru.str()
		}
	}
	match p.free_sru {
		EmptyOption {}
		i64 {
			m['free_sru'] = p.free_sru.str()
		}
	}
	match p.free_hru {
		EmptyOption {}
		i64 {
			m['free_hru'] = p.free_hru.str()
		}
	}
	match p.free_ips {
		EmptyOption {}
		i64 {
			m['free_ips'] = p.free_ips.str()
		}
	}
	if p.status != '' {
		m['status'] = p.status
	}
	if p.city != '' {
		m['city'] = p.city
	}
	if p.country != '' {
		m['country'] = p.country
	}
	if p.farm_name != '' {
		m['farm_name'] = p.farm_name
	}
	if p.ipv4 != '' {
		m['ipv4'] = p.ipv4
	}
	if p.ipv6 != '' {
		m['ipv6'] = p.ipv6
	}
	if p.domain != '' {
		m['domain'] = p.domain
	}
	match p.dedicated {
		EmptyOption {}
		bool {
			m['dedicated'] = p.dedicated.str()
		}
	}
	match p.rentable {
		EmptyOption {}
		bool {
			m['rentable'] = p.rentable.str()
		}
	}
	match p.rented_by {
		EmptyOption {}
		i64 {
			m['rented_by'] = p.rented_by.str()
		}
	}
	match p.available_for {
		EmptyOption {}
		i64 {
			m['available_for'] = p.available_for.str()
		}
	}

	if p.farm_ids.len > 0 {
		m['farm_ids'] = json.encode(p.farm_ids).all_after('[').all_before(']')
	}
	return m
}

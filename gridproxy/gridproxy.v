module gridproxy

import json
import model { GridStats, Node, NodeStatus, NodesParams, Twin, TwinParams, StatsParams }

/*
struct ErrorResponse {
	Error
	code int = 0
}

pub fn (err ErrorResponse) msg() string {
	if err.code != 0 {
		return 'HTTP error response: $err.msg'
	}
	return 'Client error: $err.msg'
}*/

pub fn (mut c GridproxyClient) get_node_by_id(node_id int) ?Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()

	res := http_client.send(prefix: 'nodes/', id: '$node_id') or { return err }

	if !res.is_ok() {
		return error(res.data)
	}

	if res.data == '' {
		return error('empty response')
	}

	node := json.decode(model.Node, res.data) or {
		return error('error to get jsonstr for node_info, json decode: node: $node_id')
	}
	return node
}

pub fn (mut c GridproxyClient) get_gateway_by_id(node_id int) ?Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()

	res := http_client.send(prefix: 'nodes/', id: '$node_id') or { return err }

	if !res.is_ok() {
		return error(res.data)
	}

	if res.data == '' {
		return error('empty response')
	}

	node := json.decode(model.Node, res.data) or {
		return error('error to get jsonstr for node_info, json decode: node: $node_id')
	}
	return node
}

pub fn (mut c GridproxyClient) get_nodes(params NodesParams) ?[]Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'nodes/', params: params_map) or { return err }

	if !res.is_ok() {
		return error(res.data)
	}

	if res.data == '' {
		return error('empty response')
	}

	nodes := json.decode([]model.Node, res.data) or {
		return error('error to get jsonstr for nodes, data: $res.data, params: $params_map')
	}
	return nodes
}

pub fn (mut c GridproxyClient) get_gateways(params NodesParams) ?[]Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'gateways/', params: params_map) or { return err }

	if !res.is_ok() {
		return error(res.data)
	}

	if res.data == '' {
		return error('empty response')
	}

	nodes := json.decode([]model.Node, res.data) or {
		return error('error to get jsonstr for nodes, data: $res.data, params: $params_map')
	}
	return nodes
}

pub fn (mut c GridproxyClient) get_stats(filter StatsParams) ?GridStats {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	mut params_map := map[string]string
	params_map["status"] = match filter.status {
		.all { "" }
		.online { "up" }
	}

	res := http_client.send(prefix: 'stats/', params: params_map) or { return err }

	if !res.is_ok() {
		return error(res.data)
	}

	if res.data == '' {
		return error('empty response')
	}

	stats := json.decode(model.GridStats, res.data) or {
		return error('error to get jsonstr for stats, data: $res.data, params: $params_map')
	}
	return stats
}

pub fn (mut c GridproxyClient) get_twins(params TwinParams) ?[]Twin {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'twins/', params: params_map) or { return err }

	if !res.is_ok() {
		return error(res.data)
	}

	if res.data == '' {
		return error('empty response')
	}

	twins := json.decode([]model.Twin, res.data) or {
		return error('error to get jsonstr for twins, data: $res.data, params: $params_map')
	}
	return twins
}

pub fn (mut c GridproxyClient) get_twin_by_id(twin_id int) ?Twin {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := {
		'twin_id': "$twin_id"
	}
	res := http_client.send(prefix: 'twins/', params: params_map) or { return err }
	println(params_map)
	if !res.is_ok() {
		return error(res.data)
	}

	if res.data == '' {
		return error('empty response')
	}

	twins := json.decode([]model.Twin, res.data) or {
		return error('error to get jsonstr for twin, data: $res.data, params: $params_map')
	}
	return twins[0]
}

pub fn (mut c GridproxyClient) check_health() bool {
	mut http_client := c.http_client.clone()
	res := http_client.send(prefix: 'ping/') or { return false }
	if !res.is_ok() {
		return false
	}
	health_map := json.decode(map[string]string, res.data) or {
		return false
	}

	if health_map["ping"] != 'pong' {
		return false
	}

	return true
}

// pub fn (mut h GridproxyClient) nodes_print(nodes []Node) string {
// 	mut res := []string{}
// 	res <<"\n\nAVAILABLE NODES (MEM in GB, SSD/HDD in TB):\n-------------------------------------------\n"
// 	for node in nodes{
// 		cru_available_gb := node.capacity.total_resources.cru - node.capacity.used_resources.cru
// 		mru_available_gb := node.capacity.total_resources.mru - node.capacity.used_resources.mru
// 		hru_available_gb := node.capacity.total_resources.hru - node.capacity.used_resources.hru
// 		sru_available_gb := node.capacity.total_resources.sru - node.capacity.used_resources.sru		
// 		res << "${node.id:-5} ${node.country:-15}${node.farm.limit(30):-31} pubip:${node.nr_pub_ipv4:-5} ${cru_available_gb:4} cores | ${mru_available_gb:4} mem | ${(f32(sru_available_gb)/1000):5.1} ssd | ${(hru_available_gb)/1000:5} hdd"
// 	}
// 	res <<"\n"
// 	return res.join_lines()
// }

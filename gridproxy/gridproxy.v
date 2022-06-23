module gridproxy

// client library for threefold gridproxy API
import json
import gridproxy.model { Contract, ContractFilter, Farm, FarmFilter, GridStats, Node, NodeWithNestedCapacity, NodesFilter, StatsFilter, Twin, TwinFilter }

/*
all errors returned by the gridproxy API or the client are wrapped in a standard `Error` object with two fields.
{
	msg string
	code int // could be API call error code or client error code
}

`code` is an error code that can be used to identify the error.
in API call errors, `code` represents the HTTP status code. (100..599)

Client errors codes are represented by numbers in the range of 1..99
currently, the following client error codes are used:
id not found error code: 4
json parsing error code: 10
http client error code: 11
invalid response from server (e.g. empty response) error code: 24
*/

// fetch specific node information by node id.
//
// * `node_id`: node id
//
// returns: node information or error
pub fn (mut c GridProxyClient) get_node_by_id(node_id u64) ?NodeWithNestedCapacity {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()

	res := http_client.send(prefix: 'nodes/', id: '$node_id') or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	node := json.decode(NodeWithNestedCapacity, res.data) or {
		return error_with_code('error to get jsonstr for node data, json decode: node id: $node_id, data: $res.data',
			10)
	}
	return node
}

// fetch specific gateway information by node id.
//
// * `node_Id`: node id
//
// returns: gateway information or error
pub fn (mut c GridProxyClient) get_gateway_by_id(node_id u64) ?NodeWithNestedCapacity {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()

	res := http_client.send(prefix: 'gateways/', id: '$node_id') or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	node := json.decode(NodeWithNestedCapacity, res.data) or {
		return error_with_code('error to get jsonstr for gateway data, json decode: gateway id: $node_id, data: $res.data',
			10)
	}
	return node
}

// fetch nodes information and public configurations.
//
// * `params`: filter object to apply to the nodes
//
// returns: array of nodes information or error
pub fn (mut c GridProxyClient) get_nodes(params NodesFilter) ?[]Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'nodes/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	nodes := json.decode([]Node, res.data) or {
		return error_with_code('error to get jsonstr for node list data, json decode: node filter: $params_map, data: $res.data',
			10)
	}
	return nodes
}

// fetch gateways information and public configurations and domains.
//
// * `params`: filter object to apply to the gateways
//
// returns: array of gateways information or error
pub fn (mut c GridProxyClient) get_gateways(params NodesFilter) ?[]Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'gateways/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	nodes := json.decode([]Node, res.data) or {
		return error_with_code('error to get jsonstr for gateways list data, json decode: gateway filter: $params_map, data: $res.data',
			10)
	}
	return nodes
}

// fetch grid statistics.
//
// * `filter`: filter object to apply to the grid statistics
//
// returns: grid statistics or error
pub fn (mut c GridProxyClient) get_stats(filter StatsFilter) ?GridStats {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	mut params_map := map[string]string{}
	params_map['status'] = match filter.status {
		.all { '' }
		.online { 'up' }
	}

	res := http_client.send(prefix: 'stats/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	stats := json.decode(GridStats, res.data) or {
		return error_with_code('error to get jsonstr for grid stats data, json decode: stats filter: $params_map, data: $res.data',
			10)
	}
	return stats
}

// fetch twins information.
//
// * `params`: filter object to apply to the twins
//
// returns: array of twins information or error
pub fn (mut c GridProxyClient) get_twins(params TwinFilter) ?[]Twin {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'twins/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	twins := json.decode([]Twin, res.data) or {
		return error_with_code('error to get jsonstr for twin list data, json decode: twin filter: $params_map, data: $res.data',
			10)
	}
	return twins
}

// fetch contracts information.
//
// * `params`: filter object to apply to the contracts
//
// returns: array of contracts information or error
pub fn (mut c GridProxyClient) get_contracts(params ContractFilter) ?[]Contract {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'contracts/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	contracts := json.decode([]Contract, res.data) or {
		return error_with_code('error to get jsonstr for contract list data, json decode: contract filter: $params_map, data: $res.data',
			10)
	}
	return contracts
}

// fetch farms information and public ips.
//
// * `params`: filter object to apply to the farms
//
// returns: array of farms information or error
pub fn (mut c GridProxyClient) get_farms(params FarmFilter) ?[]Farm {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'farms/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', 11)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', 24)
	}

	farms := json.decode([]Farm, res.data) or {
		return error_with_code('error to get jsonstr for farm list data, json decode: farm filter: $params_map, data: $res.data',
			10)
	}
	return farms
}

// fetch specific twin information by twin id.
//
// * `twin_id`: twin id
//
// returns: twin information or error
pub fn (mut c GridProxyClient) get_twin_by_id(twin_id u64) ?Twin {
	// needed to allow to use threads	
	twins := c.get_twins(twin_id: twin_id) or {
		return error_with_code('http client error: $err.msg()', 11)
	}
	if twins.len == 0 {
		return error_with_code('no twin found for id: $twin_id', 4)
	}
	return twins[0]
}

// fetch specific twin information by account.
//
// * `account_id`: account id
//
// returns: twin information or error
pub fn (mut c GridProxyClient) get_twin_by_account(account_id string) ?Twin {
	// needed to allow to use threads
	twins := c.get_twins(account_id: account_id) or {
		return error_with_code('http client error: $err.msg()', 11)
	}
	if twins.len == 0 {
		return error_with_code('no twin found for account_id: $account_id', 4)
	}
	return twins[0]
}

// check if API server is reachable and responding.
//
// returns: true if API server is reachable and responding, false otherwise
pub fn (mut c GridProxyClient) check_health() bool {
	mut http_client := c.http_client.clone()
	res := http_client.send(prefix: 'ping/') or { return false }
	if !res.is_ok() {
		return false
	}
	health_map := json.decode(map[string]string, res.data) or { return false }

	if health_map['ping'] != 'pong' {
		return false
	}

	return true
}

// pub fn (mut h GridProxyClient) nodes_print(nodes []Node) string {
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

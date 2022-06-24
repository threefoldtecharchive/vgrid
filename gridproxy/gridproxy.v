module gridproxy

// client library for threefold gridproxy API
import json
import model { Contract, ContractFilter, Farm, FarmFilter, GridStats, Node, Node_, NodesFilter, StatsFilter, Twin, TwinFilter }

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
const (
	// clinet error codes
	err_id_not_found = 4
	err_json_parse   = 10
	err_http_client  = 11
	err_invalid_resp = 24
)

// fetch specific node information by node id.
//
// * `node_id` (u64): node id.
//
// returns: `Node` or `Error`.
pub fn (mut c GridProxyClient) get_node_by_id(node_id u64) ?Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()

	res := http_client.send(prefix: 'nodes/', id: '$node_id') or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	node := json.decode(Node, res.data) or {
		return error_with_code('error to get jsonstr for node data, json decode: node id: $node_id, data: $res.data',
			gridproxy.err_json_parse)
	}
	return node
}

// fetch specific gateway information by node id.
//
// * `node_id` (u64): node id.
//
// returns: `Node` or `Error`.
pub fn (mut c GridProxyClient) get_gateway_by_id(node_id u64) ?Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()

	res := http_client.send(prefix: 'gateways/', id: '$node_id') or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	node := json.decode(Node, res.data) or {
		return error_with_code('error to get jsonstr for gateway data, json decode: gateway id: $node_id, data: $res.data',
			gridproxy.err_json_parse)
	}
	return node
}

// fetch all nodes information and public configurations with pagination.
//
// * `page` (u64): Page number. [optional].
// * `size` (u64): Max result per page. [optional].
// * `ret_count` (u64): Set nodes' count on headers based on filter. [optional].
// * `free_mru` (u64): Min free reservable mru in bytes. [optional].
// * `free_hru` (u64): Min free reservable hru in bytes. [optional].
// * `free_sru` (u64): Min free reservable sru in bytes. [optional].
// * `free_ips` (u64): Min number of free ips in the farm of the node. [optional].
// * `status` (string): Node status filter, set to 'up' to get online nodes only. [optional].
// * `city` (string): Node city filter. [optional].
// * `country` (string): Node country filter. [optional].
// * `farm_name` (string): Get nodes for specific farm. [optional].
// * `ipv4` (string): Set to true to filter nodes with ipv4. [optional].
// * `ipv6` (string): Set to true to filter nodes with ipv6. [optional].
// * `domain` (string): Set to true to filter nodes with domain. [optional].
// * `dedicated` (bool): Set to true to get the dedicated nodes only. [optional].
// * `rentable` (bool): Set to true to filter the available nodes for renting. [optional].
// * `rented_by` (u64): rented by twin id. [optional].
// * `available_for` (u64): available for twin id. [optional].
// * `farm_ids` ([]u64): List of farm ids. [optional].
//
// returns: `[]Node` or `Error`.
pub fn (mut c GridProxyClient) get_nodes(params NodesFilter) ?[]Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'nodes/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	nodes_ := json.decode([]Node_, res.data) or {
		return error_with_code('error to get jsonstr for node list data, json decode: node filter: $params_map, data: $res.data',
			gridproxy.err_json_parse)
	}
	nodes := nodes_.map(it.with_nested_capacity())
	return nodes
}

// fetch all gateways information and public configurations and domains with pagination.
//
// * `page` (u64): Page number. [optional].
// * `size` (u64): Max result per page. [optional].
// * `ret_count` (u64): Set nodes' count on headers based on filter. [optional].
// * `free_mru` (u64): Min free reservable mru in bytes. [optional].
// * `free_hru` (u64): Min free reservable hru in bytes. [optional].
// * `free_sru` (u64): Min free reservable sru in bytes. [optional].
// * `free_ips` (u64): Min number of free ips in the farm of the node. [optional].
// * `status` (string): Node status filter, set to 'up' to get online nodes only.. [optional].
// * `city` (string): Node city filter. [optional].
// * `country` (string): Node country filter. [optional].
// * `farm_name` (string): Get nodes for specific farm. [optional].
// * `ipv4` (string): Set to true to filter nodes with ipv4. [optional].
// * `ipv6` (string): Set to true to filter nodes with ipv6. [optional].
// * `domain` (string): Set to true to filter nodes with domain. [optional].
// * `dedicated` (bool): Set to true to get the dedicated nodes only. [optional].
// * `rentable` (bool): Set to true to filter the available nodes for renting. [optional].
// * `rented_by` (u64): rented by twin id. [optional].
// * `available_for` (u64): available for twin id. [optional].
// * `farm_ids` ([]u64): List of farm ids. [optional].
//
// returns: `[]Node` or `Error`.
pub fn (mut c GridProxyClient) get_gateways(params NodesFilter) ?[]Node {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'gateways/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	nodes_ := json.decode([]Node_, res.data) or {
		return error_with_code('error to get jsonstr for gateways list data, json decode: gateway filter: $params_map, data: $res.data',
			gridproxy.err_json_parse)
	}
	nodes := nodes_.map(it.with_nested_capacity())
	return nodes
}

// fetch statistics about the grid.
//
// * `status` (string): Node status filter, set to 'up' to get online nodes only.. [optional].
//
// returns: `GridStats` or `Error`.
pub fn (mut c GridProxyClient) get_stats(filter StatsFilter) ?GridStats {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	mut params_map := map[string]string{}
	params_map['status'] = match filter.status {
		.all { '' }
		.online { 'up' }
	}

	res := http_client.send(prefix: 'stats/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	stats := json.decode(GridStats, res.data) or {
		return error_with_code('error to get jsonstr for grid stats data, json decode: stats filter: $params_map, data: $res.data',
			gridproxy.err_json_parse)
	}
	return stats
}

// fetch all twins information with pagaination.
//
// * `page` (u64): Page number. [optional].
// * `size` (u64): Max result per page. [optional].
// * `ret_count` (string): Set farms' count on headers based on filter. [optional].
// * `twin_id` (u64): twin id. [optional].
// * `account_id` (string): account address. [optional].
//
// returns: `[]Twin` or `Error`.
pub fn (mut c GridProxyClient) get_twins(params TwinFilter) ?[]Twin {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'twins/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	twins := json.decode([]Twin, res.data) or {
		return error_with_code('error to get jsonstr for twin list data, json decode: twin filter: $params_map, data: $res.data',
			gridproxy.err_json_parse)
	}
	return twins
}

// fetch all contracts information with pagination.
//
// * `page` (u64): Page number. [optional].
// * `size` (u64): Max result per page. [optional].
// * `ret_count` (string): Set farms' count on headers based on filter. [optional].
// * `contract_id` (u64): contract id. [optional].
// * `twin_id` (u64): twin id. [optional].
// * `node_id` (u64): node id which contract is deployed on in case of ('rent' or 'node' contracts). [optional].
// * `name` (string): contract name in case of 'name' contracts. [optional].
// * `type` (string): contract type 'node', 'name', or 'rent'. [optional].
// * `state` (string): contract state 'Created', or 'Deleted'. [optional].
// * `deployment_data` (string): contract deployment data in case of 'node' contracts. [optional].
// * `deployment_hash` (string): contract deployment hash in case of 'node' contracts. [optional].
// * `number_of_public_ips` (u64): Min number of public ips in the 'node' contract. [optional].
//
// * returns: `[]Contract` or `Error`.
pub fn (mut c GridProxyClient) get_contracts(params ContractFilter) ?[]Contract {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'contracts/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	contracts := json.decode([]Contract, res.data) or {
		return error_with_code('error to get jsonstr for contract list data, json decode: contract filter: $params_map, data: $res.data',
			gridproxy.err_json_parse)
	}
	return contracts
}

// fetch farms information and public ips.
//
// * `page` (u64): Page number. [optional].
// * `size` (u64): Max result per page. [optional].
// * `ret_count` (string): Set farms' count on headers based on filter. [optional].
// * `free_ips` (u64): Min number of free ips in the farm. [optional].
// * `total_ips` (u64): Min number of total ips in the farm. [optional].
// * `pricing_policy_id` (u64): Pricing policy id. [optional].
// * `version` (u64): farm version. [optional].
// * `farm_id` (u64): farm id. [optional].
// * `twin_id` (u64): twin id associated with the farm. [optional].
// * `name` (string): farm name. [optional].
// * `name_contains` (string): farm name contains. [optional].
// * `certification_type` (string): certificate type DIY or Certified. [optional].
// * `dedicated` (bool): farm is dedicated. [optional].
// * `stellar_address` (string): farm stellar_address. [optional].
//
// returns: `[]Farm` or `Error`.
pub fn (mut c GridProxyClient) get_farms(params FarmFilter) ?[]Farm {
	// needed to allow to use threads
	mut http_client := c.http_client.clone()
	params_map := params.to_map()
	res := http_client.send(prefix: 'farms/', params: params_map) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}

	if !res.is_ok() {
		return error_with_code(res.data, res.code)
	}

	if res.data == '' {
		return error_with_code('empty response', gridproxy.err_invalid_resp)
	}

	farms := json.decode([]Farm, res.data) or {
		return error_with_code('error to get jsonstr for farm list data, json decode: farm filter: $params_map, data: $res.data',
			gridproxy.err_json_parse)
	}
	return farms
}

// fetch specific twin information by twin id.
//
// * `twin_id`: twin id.
//
// returns: `Twin` or `Error`.
pub fn (mut c GridProxyClient) get_twin_by_id(twin_id u64) ?Twin {
	// needed to allow to use threads	
	twins := c.get_twins(twin_id: twin_id) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}
	if twins.len == 0 {
		return error_with_code('no twin found for id: $twin_id', gridproxy.err_id_not_found)
	}
	return twins[0]
}

// fetch specific twin information by account.
//
// * `account_id`: account id.
//
// returns: `Twin` or `Error`.
pub fn (mut c GridProxyClient) get_twin_by_account(account_id string) ?Twin {
	// needed to allow to use threads
	twins := c.get_twins(account_id: account_id) or {
		return error_with_code('http client error: $err.msg()', gridproxy.err_http_client)
	}
	if twins.len == 0 {
		return error_with_code('no twin found for account_id: $account_id', gridproxy.err_id_not_found)
	}
	return twins[0]
}

// check if API server is reachable and responding.
//
// returns: bool, `true` if API server is reachable and responding, `false` otherwise
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

// pub fn (mut h GridProxyClient) nodes_pru64(nodes []Node_) string {
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

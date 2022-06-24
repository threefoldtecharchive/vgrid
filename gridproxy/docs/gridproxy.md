# module gridproxy




## Contents
- [module gridproxy](#module-gridproxy)
  - [Contents](#contents)
  - [get](#get)
  - [TFGridNet](#tfgridnet)
  - [GridProxyClient](#gridproxyclient)
  - [check_health](#check_health)
  - [get_contracts](#get_contracts)
  - [get_farms](#get_farms)
  - [get_gateway_by_id](#get_gateway_by_id)
  - [get_gateways](#get_gateways)
  - [get_node_by_id](#get_node_by_id)
  - [get_nodes](#get_nodes)
  - [get_stats](#get_stats)
  - [get_twin_by_account](#get_twin_by_account)
  - [get_twin_by_id](#get_twin_by_id)
  - [get_twins](#get_twins)
      - [Powered by vdoc. Generated on: 24 Jun 2022 19:39:46](#powered-by-vdoc-generated-on-24-jun-2022-193946)

## get
```v
fn get(net TFGridNet, use_redis_cache bool) &GridProxyClient
```


[[Return to contents]](#Contents)

## TFGridNet
```v
enum TFGridNet {
	main
	test
	dev
	qa
}
```


[[Return to contents]](#Contents)

## GridProxyClient
```v
struct GridProxyClient {
pub mut:
	http_client httpconnection.HTTPConnection
}
```


[[Return to contents]](#Contents)

## check_health
```v
fn (mut c GridProxyClient) check_health() bool
```

check if API server is reachable and responding.  

returns: bool, `true` if API server is reachable and responding, `false` otherwise

[[Return to contents]](#Contents)

## get_contracts
```v
fn (mut c GridProxyClient) get_contracts(params ContractFilter) ?[]Contract
```

fetch all contracts information with pagination.  

* `page` (u64): Page number. [optional].  
* `size` (u64): Max result per page. [optional].  
* `ret_count` (string): Set farms' count on headers based on filter. [optional].  
* `contract_id` (u64): contract id. [optional].  
* `twin_id` (u64): twin id. [optional].  
* `node_id` (u64): node id which contract is deployed on in case of ('rent' or 'node' contracts). [optional].  
* `name` (string): contract name in case of 'name' contracts. [optional].  
* `type` (string): contract type 'node', 'name', or 'rent'. [optional].  
* `state` (string): contract state 'Created', or 'Deleted'. [optional].  
* `deployment_data` (string): contract deployment data in case of 'node' contracts. [optional].  
* `deployment_hash` (string): contract deployment hash in case of 'node' contracts. [optional].  
* `number_of_public_ips` (u64): Min number of public ips in the 'node' contract. [optional].  

* returns: `[]Contract` or `Error`.  

[[Return to contents]](#Contents)

## get_farms
```v
fn (mut c GridProxyClient) get_farms(params FarmFilter) ?[]Farm
```

fetch farms information and public ips.  

* `page` (u64): Page number. [optional].  
* `size` (u64): Max result per page. [optional].  
* `ret_count` (string): Set farms' count on headers based on filter. [optional].  
* `free_ips` (u64): Min number of free ips in the farm. [optional].  
* `total_ips` (u64): Min number of total ips in the farm. [optional].  
* `pricing_policy_id` (u64): Pricing policy id. [optional].  
* `version` (u64): farm version. [optional].  
* `farm_id` (u64): farm id. [optional].  
* `twin_id` (u64): twin id associated with the farm. [optional].  
* `name` (string): farm name. [optional].  
* `name_contains` (string): farm name contains. [optional].  
* `certification_type` (string): certificate type DIY or Certified. [optional].  
* `dedicated` (bool): farm is dedicated. [optional].  
* `stellar_address` (string): farm stellar_address. [optional].  

returns: `[]Farm` or `Error`.  

[[Return to contents]](#Contents)

## get_gateway_by_id
```v
fn (mut c GridProxyClient) get_gateway_by_id(node_id u64) ?Node
```

fetch specific gateway information by node id.  

* `node_id` (u64): node id.  

returns: `Node` or `Error`.  

[[Return to contents]](#Contents)

## get_gateways
```v
fn (mut c GridProxyClient) get_gateways(params NodesFilter) ?[]Node
```

fetch all gateways information and public configurations and domains with pagination.  

* `page` (u64): Page number. [optional].  
* `size` (u64): Max result per page. [optional].  
* `ret_count` (u64): Set nodes' count on headers based on filter. [optional].  
* `free_mru` (u64): Min free reservable mru in bytes. [optional].  
* `free_hru` (u64): Min free reservable hru in bytes. [optional].  
* `free_sru` (u64): Min free reservable sru in bytes. [optional].  
* `free_ips` (u64): Min number of free ips in the farm of the node. [optional].  
* `status` (string): Node status filter, set to 'up' to get online nodes only.. [optional].  
* `city` (string): Node city filter. [optional].  
* `country` (string): Node country filter. [optional].  
* `farm_name` (string): Get nodes for specific farm. [optional].  
* `ipv4` (string): Set to true to filter nodes with ipv4. [optional].  
* `ipv6` (string): Set to true to filter nodes with ipv6. [optional].  
* `domain` (string): Set to true to filter nodes with domain. [optional].  
* `dedicated` (bool): Set to true to get the dedicated nodes only. [optional].  
* `rentable` (bool): Set to true to filter the available nodes for renting. [optional].  
* `rented_by` (u64): rented by twin id. [optional].  
* `available_for` (u64): available for twin id. [optional].  
* `farm_ids` ([]u64): List of farm ids. [optional].  

returns: `[]Node` or `Error`.  

[[Return to contents]](#Contents)

## get_node_by_id
```v
fn (mut c GridProxyClient) get_node_by_id(node_id u64) ?Node
```

fetch specific node information by node id.  

* `node_id` (u64): node id.  

returns: `Node` or `Error`.  

[[Return to contents]](#Contents)

## get_nodes
```v
fn (mut c GridProxyClient) get_nodes(params NodesFilter) ?[]Node
```

fetch all nodes information and public configurations with pagination.  

* `page` (u64): Page number. [optional].  
* `size` (u64): Max result per page. [optional].  
* `ret_count` (u64): Set nodes' count on headers based on filter. [optional].  
* `free_mru` (u64): Min free reservable mru in bytes. [optional].  
* `free_hru` (u64): Min free reservable hru in bytes. [optional].  
* `free_sru` (u64): Min free reservable sru in bytes. [optional].  
* `free_ips` (u64): Min number of free ips in the farm of the node. [optional].  
* `status` (string): Node status filter, set to 'up' to get online nodes only. [optional].  
* `city` (string): Node city filter. [optional].  
* `country` (string): Node country filter. [optional].  
* `farm_name` (string): Get nodes for specific farm. [optional].  
* `ipv4` (string): Set to true to filter nodes with ipv4. [optional].  
* `ipv6` (string): Set to true to filter nodes with ipv6. [optional].  
* `domain` (string): Set to true to filter nodes with domain. [optional].  
* `dedicated` (bool): Set to true to get the dedicated nodes only. [optional].  
* `rentable` (bool): Set to true to filter the available nodes for renting. [optional].  
* `rented_by` (u64): rented by twin id. [optional].  
* `available_for` (u64): available for twin id. [optional].  
* `farm_ids` ([]u64): List of farm ids. [optional].  

returns: `[]Node` or `Error`.  

[[Return to contents]](#Contents)

## get_stats
```v
fn (mut c GridProxyClient) get_stats(filter StatsFilter) ?GridStats
```

fetch statistics about the grid.  

* `status` (string): Node status filter, set to 'up' to get online nodes only.. [optional].  

returns: `GridStats` or `Error`.  

[[Return to contents]](#Contents)

## get_twin_by_account
```v
fn (mut c GridProxyClient) get_twin_by_account(account_id string) ?Twin
```

fetch specific twin information by account.  

* `account_id`: account id.  

returns: `Twin` or `Error`.  

[[Return to contents]](#Contents)

## get_twin_by_id
```v
fn (mut c GridProxyClient) get_twin_by_id(twin_id u64) ?Twin
```

fetch specific twin information by twin id.  

* `twin_id`: twin id.  

returns: `Twin` or `Error`.  

[[Return to contents]](#Contents)

## get_twins
```v
fn (mut c GridProxyClient) get_twins(params TwinFilter) ?[]Twin
```

fetch all twins information with pagaination.  

* `page` (u64): Page number. [optional].  
* `size` (u64): Max result per page. [optional].  
* `ret_count` (string): Set farms' count on headers based on filter. [optional].  
* `twin_id` (u64): twin id. [optional].  
* `account_id` (string): account address. [optional].  

returns: `[]Twin` or `Error`.  

[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 24 Jun 2022 19:39:46

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
      - [Powered by vdoc. Generated on: 22 Jun 2022 23:49:30](#powered-by-vdoc-generated-on-22-jun-2022-234930)

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

[[Return to contents]](#Contents)

## get_contracts
```v
fn (mut c GridProxyClient) get_contracts(params ContractFilter) ?[]Contract
```

fetch contracts information.  

[[Return to contents]](#Contents)

## get_farms
```v
fn (mut c GridProxyClient) get_farms(params FarmFilter) ?[]Farm
```

fetch farms information and public ips.  

[[Return to contents]](#Contents)

## get_gateway_by_id
```v
fn (mut c GridProxyClient) get_gateway_by_id(node_id u64) ?NodeWithNestedCapacity
```

fetch specific gateway information by node id.  

[[Return to contents]](#Contents)

## get_gateways
```v
fn (mut c GridProxyClient) get_gateways(params NodesFilter) ?[]Node
```

fetch gateways information and public configurations and domains

[[Return to contents]](#Contents)

## get_node_by_id
```v
fn (mut c GridProxyClient) get_node_by_id(node_id u64) ?NodeWithNestedCapacity
```

fetch specific node information by node id.  

[[Return to contents]](#Contents)

## get_nodes
```v
fn (mut c GridProxyClient) get_nodes(params NodesFilter) ?[]Node
```

fetch nodes information and public configurations.  

[[Return to contents]](#Contents)

## get_stats
```v
fn (mut c GridProxyClient) get_stats(filter StatsFilter) ?GridStats
```

fetch grid statistics.  

[[Return to contents]](#Contents)

## get_twin_by_account
```v
fn (mut c GridProxyClient) get_twin_by_account(account_id string) ?Twin
```

fetch specific twin information by account.  

[[Return to contents]](#Contents)

## get_twin_by_id
```v
fn (mut c GridProxyClient) get_twin_by_id(twin_id u64) ?Twin
```

fetch specific twin information by twin id.  

[[Return to contents]](#Contents)

## get_twins
```v
fn (mut c GridProxyClient) get_twins(params TwinFilter) ?[]Twin
```

fetch twins information.  

[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 22 Jun 2022 23:49:30
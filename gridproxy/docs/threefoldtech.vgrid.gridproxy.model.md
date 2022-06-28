# module threefoldtech.vgrid.gridproxy.model




## Contents
- [ByteUnit](#ByteUnit)
  - [to_megabytes](#to_megabytes)
  - [to_gigabytes](#to_gigabytes)
  - [to_terabytes](#to_terabytes)
  - [str](#str)
- [ContractGetter](#ContractGetter)
- [FarmGetter](#FarmGetter)
- [NodeGetter](#NodeGetter)
- [SecondUnit](#SecondUnit)
  - [to_minutes](#to_minutes)
  - [to_hours](#to_hours)
  - [to_days](#to_days)
  - [str](#str)
- [TFTUnit](#TFTUnit)
  - [to_utft](#to_utft)
  - [to_mtft](#to_mtft)
  - [to_tft](#to_tft)
- [TwinGetter](#TwinGetter)
- [UnixTime](#UnixTime)
  - [to_time](#to_time)
  - [str](#str)
- [NodeStatus](#NodeStatus)
- [Contract](#Contract)
  - [total_billed](#total_billed)
- [ContractBilling](#ContractBilling)
- [ContractFilter](#ContractFilter)
  - [to_map](#to_map)
- [ContractIterator](#ContractIterator)
  - [next](#next)
- [Farm](#Farm)
- [FarmFilter](#FarmFilter)
  - [to_map](#to_map)
- [FarmIterator](#FarmIterator)
  - [next](#next)
- [GridStat](#GridStat)
- [Node](#Node)
  - [calc_available_resources](#calc_available_resources)
  - [is_online](#is_online)
- [Node_](#Node_)
  - [with_nested_capacity](#with_nested_capacity)
- [NodeCapacity](#NodeCapacity)
- [NodeContractDetails](#NodeContractDetails)
- [NodeFilter](#NodeFilter)
  - [to_map](#to_map)
- [NodeIterator](#NodeIterator)
  - [next](#next)
- [NodeLocation](#NodeLocation)
- [NodeResources](#NodeResources)
- [PublicConfig](#PublicConfig)
- [PublicIP](#PublicIP)
- [ResourceFilter](#ResourceFilter)
- [StatFilter](#StatFilter)
- [Twin](#Twin)
- [TwinFilter](#TwinFilter)
  - [to_map](#to_map)
- [TwinIterator](#TwinIterator)
  - [next](#next)

## ByteUnit
## to_megabytes
```v
fn (u ByteUnit) to_megabytes() f64
```


[[Return to contents]](#Contents)

## to_gigabytes
```v
fn (u ByteUnit) to_gigabytes() f64
```


[[Return to contents]](#Contents)

## to_terabytes
```v
fn (u ByteUnit) to_terabytes() f64
```


[[Return to contents]](#Contents)

## str
```v
fn (u ByteUnit) str() string
```


[[Return to contents]](#Contents)

## ContractGetter
```v
type ContractGetter = fn (ContractFilter) ?[]Contract
```


[[Return to contents]](#Contents)

## FarmGetter
```v
type FarmGetter = fn (FarmFilter) ?[]Farm
```


[[Return to contents]](#Contents)

## NodeGetter
```v
type NodeGetter = fn (NodeFilter) ?[]Node
```


[[Return to contents]](#Contents)

## SecondUnit
## to_minutes
```v
fn (u SecondUnit) to_minutes() f64
```


[[Return to contents]](#Contents)

## to_hours
```v
fn (u SecondUnit) to_hours() f64
```


[[Return to contents]](#Contents)

## to_days
```v
fn (u SecondUnit) to_days() f64
```


[[Return to contents]](#Contents)

## str
```v
fn (u SecondUnit) str() string
```


[[Return to contents]](#Contents)

## TFTUnit
## to_utft
```v
fn (t TFTUnit) to_utft() f64
```


[[Return to contents]](#Contents)

## to_mtft
```v
fn (t TFTUnit) to_mtft() f64
```


[[Return to contents]](#Contents)

## to_tft
```v
fn (t TFTUnit) to_tft() f64
```


[[Return to contents]](#Contents)

## TwinGetter
```v
type TwinGetter = fn (TwinFilter) ?[]Twin
```


[[Return to contents]](#Contents)

## UnixTime
## to_time
```v
fn (t UnixTime) to_time() Time
```


[[Return to contents]](#Contents)

## str
```v
fn (t UnixTime) str() string
```


[[Return to contents]](#Contents)

## NodeStatus
```v
enum NodeStatus {
	all
	online
}
```


[[Return to contents]](#Contents)

## Contract
```v
struct Contract {
pub:
	contract_id   u64                 [json: contractId]
	twin_id       u64                 [json: twinId]
	state         string              [json: state]
	created_at    UnixTime            [json: created_at]
	contract_type string              [json: 'type']
	details       NodeContractDetails [json: details]
	billing       []ContractBilling   [json: billing]
}
```


[[Return to contents]](#Contents)

## total_billed
```v
fn (c &Contract) total_billed() TFTUnit
```

total_billed returns the total amount billed for the contract.  

returns: `TFTUnit`

[[Return to contents]](#Contents)

## ContractBilling
```v
struct ContractBilling {
pub:
	amount_billed     TFTUnit  [json: amountBilled]
	discount_received string   [json: discountReceived]
	timestamp         UnixTime [json: timestamp]
}
```


[[Return to contents]](#Contents)

## ContractFilter
```v
struct ContractFilter {
pub mut:
	page                 u64 | EmptyOption = EmptyOption{}
	size                 u64 | EmptyOption = EmptyOption{}
	ret_count            u64 | EmptyOption = EmptyOption{}
	contract_id          u64 | EmptyOption = EmptyOption{}
	twin_id              u64 | EmptyOption = EmptyOption{}
	node_id              u64 | EmptyOption = EmptyOption{}
	contract_type        string
	state                string
	name                 string
	number_of_public_ips u64 | EmptyOption = EmptyOption{}
	deployment_data      string
	deployment_hash      string
}
```


[[Return to contents]](#Contents)

## to_map
```v
fn (f &ContractFilter) to_map() map[string]string
```

serialize ContractFilter to map

[[Return to contents]](#Contents)

## ContractIterator
```v
struct ContractIterator {
pub mut:
	filter ContractFilter
pub:
	get_func ContractGetter
}
```


[[Return to contents]](#Contents)

## next
```v
fn (mut i ContractIterator) next() ?[]Contract
```


[[Return to contents]](#Contents)

## Farm
```v
struct Farm {
pub:
	name               string
	farm_id            u64        [json: farmId]
	twin_id            u64        [json: twinId]
	pricing_policy_id  u64        [json: pricingPolicyId]
	certification_type string     [json: certificationType]
	stellar_address    string     [json: stellarAddress]
	dedicated          bool
	public_ips         []PublicIP [json: publicIps]
}
```


[[Return to contents]](#Contents)

## FarmFilter
```v
struct FarmFilter {
pub mut:
	page               u64 | EmptyOption = EmptyOption{}
	size               u64 | EmptyOption = EmptyOption{}
	ret_count          u64 | EmptyOption = EmptyOption{}
	free_ips           u64 | EmptyOption = EmptyOption{}
	total_ips          u64 | EmptyOption = EmptyOption{}
	stellar_address    string
	pricing_policy_id  u64 | EmptyOption = EmptyOption{}
	farm_id            u64 | EmptyOption = EmptyOption{}
	twin_id            u64 | EmptyOption = EmptyOption{}
	name               string
	name_contains      string
	certification_type string
	dedicated          bool | EmptyOption = EmptyOption{}
}
```


[[Return to contents]](#Contents)

## to_map
```v
fn (f &FarmFilter) to_map() map[string]string
```

serialize FarmFilter to map

[[Return to contents]](#Contents)

## FarmIterator
```v
struct FarmIterator {
pub mut:
	filter FarmFilter
pub:
	get_func FarmGetter
}
```


[[Return to contents]](#Contents)

## next
```v
fn (mut i FarmIterator) next() ?[]Farm
```


[[Return to contents]](#Contents)

## GridStat
```v
struct GridStat {
pub:
	nodes              u64
	farms              u64
	countries          u64
	total_cru          u64            [json: totalCru]
	total_sru          ByteUnit       [json: totalSru]
	total_mru          ByteUnit       [json: totalMru]
	total_hru          ByteUnit       [json: totalHru]
	public_ips         u64            [json: publicIps]
	access_nodes       u64            [json: accessNodes]
	gateways           u64
	twins              u64
	contracts          u64
	nodes_distribution map[string]u64 [json: nodesDistribution]
}
```


[[Return to contents]](#Contents)

## Node
```v
struct Node {
pub:
	id                string
	node_id           u64          [json: nodeId]
	farm_id           u64          [json: farmId]
	twin_id           u64          [json: twinId]
	grid_version      u64          [json: gridVersion]
	uptime            SecondUnit
	created           UnixTime     [json: created]
	farming_policy_id u64          [json: farmingPolicyId]
	updated_at        UnixTime     [json: updatedAt]
	capacity          NodeCapacity
	location          NodeLocation
	public_config     PublicConfig [json: publicConfig]
	certification     string       [json: certificationType]
	status            string
	dedicated         bool
	rent_contract_id  u64          [json: rentContractId]
	rented_by_twin_id u64          [json: rentedByTwinId]
}
```


[[Return to contents]](#Contents)

## calc_available_resources
```v
fn (n &Node) calc_available_resources() NodeResources
```

calc_available_resources calculate the reservable capacity of the node.  

Returns: `NodeResources`

[[Return to contents]](#Contents)

## is_online
```v
fn (n &Node) is_online() bool
```

is_online returns true if the node is online, otherwise false.  

[[Return to contents]](#Contents)

## Node_
```v
struct Node_ {
pub:
	id                string
	node_id           u64           [json: nodeId]
	farm_id           u64           [json: farmId]
	twin_id           u64           [json: twinId]
	grid_version      u64           [json: gridVersion]
	uptime            SecondUnit
	created           UnixTime      [json: created]
	farming_policy_id u64           [json: farmingPolicyId]
	updated_at        UnixTime      [json: updatedAt]
	total_resources   NodeResources
	used_resources    NodeResources
	location          NodeLocation
	public_config     PublicConfig  [json: publicConfig]
	certification     string        [json: certificationType]
	status            string
	dedicated         bool
	rent_contract_id  u64           [json: rentContractId]
	rented_by_twin_id u64           [json: rentedByTwinId]
}
```

this is ugly, but it works. we need two models for `Node` and reimplemnt the same fields expcept for capacity srtucture it's a hack to make the json parser work as the gridproxy API have some inconsistencies see for more context: https://github.com/threefoldtech/tfgridclient_proxy/issues/164

[[Return to contents]](#Contents)

## with_nested_capacity
```v
fn (n &Node_) with_nested_capacity() Node
```

with_nested_capacity enable the client to have one representation of the node model

[[Return to contents]](#Contents)

## NodeCapacity
```v
struct NodeCapacity {
pub:
	total_resources NodeResources
	used_resources  NodeResources
}
```


[[Return to contents]](#Contents)

## NodeContractDetails
```v
struct NodeContractDetails {
pub:
	node_id              u64    [json: nodeId]
	deployment_data      string [json: deployment_data]
	deployment_hash      string [json: deployment_hash]
	number_of_public_ips u64    [json: number_of_public_ips]
}
```


[[Return to contents]](#Contents)

## NodeFilter
```v
struct NodeFilter {
pub mut:
	page          u64 | EmptyOption = EmptyOption{}
	size          u64 | EmptyOption = EmptyOption{}
	ret_count     u64 | EmptyOption = EmptyOption{}
	free_mru      u64 | EmptyOption = EmptyOption{}
	free_sru      u64 | EmptyOption = EmptyOption{}
	free_hru      u64 | EmptyOption = EmptyOption{}
	free_ips      u64 | EmptyOption = EmptyOption{}
	city          string
	country       string
	farm_name     string
	ipv4          string
	ipv6          string
	domain        string
	status        string
	dedicated     bool | EmptyOption = EmptyOption{}
	rentable      bool | EmptyOption = EmptyOption{}
	rented_by     u64 | EmptyOption  = EmptyOption{}
	available_for u64 | EmptyOption  = EmptyOption{}
	farm_ids      []u64
}
```


[[Return to contents]](#Contents)

## to_map
```v
fn (p &NodeFilter) to_map() map[string]string
```

serialize NodeFilter to map

[[Return to contents]](#Contents)

## NodeIterator
```v
struct NodeIterator {
pub mut:
	filter NodeFilter
pub:
	get_func NodeGetter
}
```


[[Return to contents]](#Contents)

## next
```v
fn (mut i NodeIterator) next() ?[]Node
```


[[Return to contents]](#Contents)

## NodeLocation
```v
struct NodeLocation {
pub:
	country string
	city    string
}
```


[[Return to contents]](#Contents)

## NodeResources
```v
struct NodeResources {
pub:
	cru u64
	mru ByteUnit
	sru ByteUnit
	hru ByteUnit
}
```


[[Return to contents]](#Contents)

## PublicConfig
```v
struct PublicConfig {
pub:
	domain string
	gw4    string
	gw6    string
	ipv4   string
	ipv6   string
}
```


[[Return to contents]](#Contents)

## PublicIP
```v
struct PublicIP {
pub:
	id          string
	ip          string
	farm_id     string [json: farmId]
	contract_id int    [json: contractId]
	gateway     string
}
```


[[Return to contents]](#Contents)

## ResourceFilter
```v
struct ResourceFilter {
pub mut:
	free_mru_gb u64
	free_sru_gb u64
	free_hru_gb u64
	free_ips    u64
}
```


[[Return to contents]](#Contents)

## StatFilter
```v
struct StatFilter {
pub mut:
	status NodeStatus
}
```


[[Return to contents]](#Contents)

## Twin
```v
struct Twin {
pub:
	twin_id    u64    [json: twinId]
	account_id string [json: accountId]
	ip         string
}
```


[[Return to contents]](#Contents)

## TwinFilter
```v
struct TwinFilter {
pub mut:
	page       u64 | EmptyOption = EmptyOption{}
	size       u64 | EmptyOption = EmptyOption{}
	ret_count  string
	twin_id    u64 | EmptyOption = EmptyOption{}
	account_id string
}
```


[[Return to contents]](#Contents)

## to_map
```v
fn (p &TwinFilter) to_map() map[string]string
```

serialize TwinFilter to map

[[Return to contents]](#Contents)

## TwinIterator
```v
struct TwinIterator {
pub mut:
	filter TwinFilter
pub:
	get_func TwinGetter
}
```


[[Return to contents]](#Contents)

## next
```v
fn (mut i TwinIterator) next() ?[]Twin
```


[[Return to contents]](#Contents)

#### Powered by vdoc. Generated on: 28 Jun 2022 13:01:22

module gridproxy

import gridproxy.model
import time

const (
	cache      = false
	dummy_node = model.Node{
		id: '0000129706-000001-c1e78'
		node_id: 1
		farm_id: 2
		twin_id: 8
		grid_version: 3
		uptime: model.SecondUnit(86400) // 86400 seconds = 1440 minutes = 24 hours = 1 day
		created: model.UnixTime(1654848126) // GMT: 2022-06-10 08:02:06
		farming_policy_id: 1
		updated_at: model.UnixTime(1654848132) // GMT: 2022-06-10 08:02:12
		total_resources: model.NodeResources{
			cru: 4
			mru: model.ByteUnit(5178437632) // 5178437632 bytes = 5178.437632 megabytes = 5.2 gigabytes = 0.005178437632 terabytes
			sru: model.ByteUnit(1610612736000) // 1610612736000 bytes = 1610612.736000 megabytes = 1610.612736 gigabytes = 16.1 terabytes
			hru: model.ByteUnit(1073741824000) // 1073741824000 bytes = 1073741.824 megabytes = 1073.741824 gigabytes = 10.7 terabytes
		}
		used_resources: model.NodeResources{
			cru: 0
			mru: model.ByteUnit(0)
			sru: model.ByteUnit(0)
			hru: model.ByteUnit(0)
		}
		location: model.NodeLocation{
			country: 'Belgium'
			city: 'Lochristi'
		}
		public_config: model.PublicConfig{
			domain: ''
			gw4: ''
			gw6: ''
			ipv4: ''
			ipv6: ''
		}
		certification: 'Diy'
		status: 'down'
		dedicated: false
		rent_contract_id: 0
		rented_by_twin_id: 0
	}
	dummy_node_with_nested_capacity = model.NodeWithNestedCapacity{
		id: '0000129706-000001-c1e78'
		node_id: 1
		farm_id: 2
		twin_id: 8
		grid_version: 3
		uptime: model.SecondUnit(86400) // 86400 seconds = 1440 minutes = 24 hours = 1 day
		created: model.UnixTime(1654848126) // GMT: 2022-06-10 08:02:06
		farming_policy_id: 1
		updated_at: model.UnixTime(1654848132) // GMT: 2022-06-10 08:02:12
		capacity: model.NodeCapacity{
			total_resources: model.NodeResources{
				cru: 4
				mru: model.ByteUnit(5178437632)
				sru: model.ByteUnit(1610612736000)
				hru: model.ByteUnit(1073741824000)
			}
			used_resources: model.NodeResources{
				cru: 0
				mru: model.ByteUnit(0)
				sru: model.ByteUnit(0)
				hru: model.ByteUnit(0)
			}
		}
		location: model.NodeLocation{
			country: 'Belgium'
			city: 'Lochristi'
		}
		public_config: model.PublicConfig{
			domain: ''
			gw4: ''
			gw6: ''
			ipv4: ''
			ipv6: ''
		}
		certification: 'Diy'
		status: 'down'
		dedicated: false
		rent_contract_id: 0
		rented_by_twin_id: 0
	}
	dummy_contract_billing = model.ContractBilling{
		amount_billed: model.TFTUnit(10000000) // 1 TFT == 1000 mTFT == 1000000 uTFT
		discount_received: 'None'
		timestamp: model.UnixTime(1655118966)
	}
)

fn test_create_gridproxy_client_qa() {
	mut gp := get(.qa, gridproxy.cache)
	assert gp.check_health() == true
}

fn test_create_gridproxy_client_dev() {
	mut gp := get(.dev, gridproxy.cache)
	assert gp.check_health() == true
}

fn test_create_gridproxy_client_test() {
	mut gp := get(.test, gridproxy.cache)
	assert gp.check_health() == true
}

fn test_create_gridproxy_client_main() {
	mut gp := get(.main, gridproxy.cache)
	assert gp.check_health() == true
}

fn test_get_nodes_qa() {
	mut gp := get(.qa, gridproxy.cache)
	nodes := gp.get_nodes() or { panic('Failed to get nodes') }
	assert nodes.len > 0
}

fn test_get_nodes_dev() {
	mut gp := get(.dev, gridproxy.cache)
	nodes := gp.get_nodes() or { panic('Failed to get nodes') }
	assert nodes.len > 0
}

fn test_get_nodes_test() {
	mut gp := get(.test, gridproxy.cache)
	nodes := gp.get_nodes() or { panic('Failed to get nodes') }
	assert nodes.len > 0
}

fn test_get_nodes_main() {
	mut gp := get(.main, gridproxy.cache)
	nodes := gp.get_nodes() or { panic('Failed to get nodes') }
	assert nodes.len > 0
}

fn test_get_gateways_qa() {
	mut gp := get(.qa, gridproxy.cache)
	nodes := gp.get_gateways() or { panic('Failed to get gateways') }
	assert nodes.len > 0
}

fn test_get_gateways_dev() {
	mut gp := get(.dev, gridproxy.cache)
	nodes := gp.get_gateways() or { panic('Failed to get gateways') }
	assert nodes.len > 0
}

fn test_get_gateways_test() {
	mut gp := get(.test, gridproxy.cache)
	nodes := gp.get_gateways() or { panic('Failed to get gateways') }
	assert nodes.len > 0
}

fn test_get_gateways_main() {
	mut gp := get(.main, gridproxy.cache)
	nodes := gp.get_gateways() or { panic('Failed to get gateways') }
	assert nodes.len > 0
}

fn test_get_twins_qa() {
	mut gp := get(.qa, gridproxy.cache)
	twins := gp.get_twins() or { panic('Failed to get twins') }
	assert twins.len > 0
}

fn test_get_twins_dev() {
	mut gp := get(.dev, gridproxy.cache)
	twins := gp.get_twins() or { panic('Failed to get twins') }
	assert twins.len > 0
}

fn test_get_twins_test() {
	mut gp := get(.test, gridproxy.cache)
	twins := gp.get_twins() or { panic('Failed to get twins') }
	assert twins.len > 0
}

/*
fn test_get_twins_main() {
	mut gp := get(.main, cache)
	twins := gp.get_twins() or {
		panic("Failed to get twins")
	}
	assert(twins.len > 0)
}*/

fn test_get_stats_qa() {
	mut gp := get(.qa, gridproxy.cache)
	stats := gp.get_stats() or { panic('Failed to get stats') }
	assert stats.nodes > 0
}

fn test_get_stats_dev() {
	mut gp := get(.dev, gridproxy.cache)
	stats := gp.get_stats() or { panic('Failed to get stats') }
	assert stats.nodes > 0
}

fn test_get_stats_test() {
	mut gp := get(.test, gridproxy.cache)
	stats := gp.get_stats() or { panic('Failed to get stats') }
	assert stats.nodes > 0
}

fn test_get_stats_main() {
	mut gp := get(.test, gridproxy.cache)
	stats := gp.get_stats() or { panic('Failed to get stats') }
	assert stats.nodes > 0
}

fn test_get_contracts_qa() {
	mut gp := get(.qa, gridproxy.cache)
	contracts := gp.get_contracts() or { panic('Failed to get contracts') }
	assert contracts.len > 0
}

fn test_get_contracts_dev() {
	mut gp := get(.dev, gridproxy.cache)
	contracts := gp.get_contracts() or { panic('Failed to get contracts') }
	assert contracts.len > 0
}

fn test_get_contracts_test() {
	mut gp := get(.test, gridproxy.cache)
	contracts := gp.get_contracts() or { panic('Failed to get contracts') }
	assert contracts.len > 0
}

/*
fn test_get_contracts_main() {
	mut gp := get(.main, cache)
	contracts := gp.get_contracts() or { panic('Failed to get contracts') }
	assert contracts.len > 0
}*/

fn test_get_farms_qa() {
	mut gp := get(.qa, gridproxy.cache)
	farms := gp.get_farms() or { panic('Failed to get farms') }
	assert farms.len > 0
}

fn test_get_farms_dev() {
	mut gp := get(.dev, gridproxy.cache)
	farms := gp.get_farms() or { panic('Failed to get farms') }
	assert farms.len > 0
}

fn test_get_farms_test() {
	mut gp := get(.test, gridproxy.cache)
	farms := gp.get_farms() or { panic('Failed to get farms') }
	assert farms.len > 0
}

fn test_get_farms_main() {
	mut gp := get(.main, gridproxy.cache)
	farms := gp.get_farms() or { panic('Failed to get farms') }
	assert farms.len > 0
}

fn test_elapsed_seconds_conversion() {
	assert gridproxy.dummy_node.uptime.to_minutes() == 1440
	assert gridproxy.dummy_node.uptime.to_hours() == 24
	assert gridproxy.dummy_node.uptime.to_days() == 1
}

fn test_timestamp_conversion() {
	assert gridproxy.dummy_node.created.to_time() == time.unix(1654848126)
	assert gridproxy.dummy_node.updated_at.to_time() == time.unix(1654848132)
}

fn test_storage_unit_conversion() {
	assert gridproxy.dummy_node.total_resources.mru.to_megabytes() == 5178.437632
	assert gridproxy.dummy_node.total_resources.mru.to_gigabytes() == 5.178437632
	assert gridproxy.dummy_node.total_resources.mru.to_terabytes() == 0.005178437632
}

fn test_tft_conversion() {
	assert gridproxy.dummy_contract_billing.amount_billed.to_tft() == 1
	assert gridproxy.dummy_contract_billing.amount_billed.to_mtft() == 1000
	assert gridproxy.dummy_contract_billing.amount_billed.to_utft() == 1000000
}

fn test_calc_available_resources_on_node() {
	// dummy node was created with 0 used resources
	assert gridproxy.dummy_node.calc_available_resources().mru == gridproxy.dummy_node.total_resources.mru
	assert gridproxy.dummy_node.calc_available_resources().hru == gridproxy.dummy_node.total_resources.hru
	assert gridproxy.dummy_node.calc_available_resources().sru == gridproxy.dummy_node.total_resources.sru
	assert gridproxy.dummy_node.calc_available_resources().cru == gridproxy.dummy_node.total_resources.cru
}

fn test_calc_available_resources_on_node_with_nested_capacity() {
	// dummy node was created with 0 used resources
	assert gridproxy.dummy_node_with_nested_capacity.calc_available_resources().mru == gridproxy.dummy_node.total_resources.mru
	assert gridproxy.dummy_node_with_nested_capacity.calc_available_resources().hru == gridproxy.dummy_node.total_resources.hru
	assert gridproxy.dummy_node_with_nested_capacity.calc_available_resources().sru == gridproxy.dummy_node.total_resources.sru
	assert gridproxy.dummy_node_with_nested_capacity.calc_available_resources().cru == gridproxy.dummy_node.total_resources.cru
}

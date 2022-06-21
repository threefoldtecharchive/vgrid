module gridproxy

fn test_get_gridproxy_qa() {
	mut gp := get(.qa, false)
	assert(gp.check_health() == true)
}

fn test_get_gridproxy_dev() {
	mut gp := get(.dev, false)
	assert(gp.check_health() == true)
}

fn test_get_gridproxy_test() {
	mut gp := get(.test, false)
	assert(gp.check_health() == true)
}

fn test_get_gridproxy_main() {
	mut gp := get(.main, false)
	assert(gp.check_health() == true)
}

fn test_get_nodes_qa() {
	mut gp := get(.qa, false)
	nodes := gp.get_nodes() or {
		panic("Failed to get nodes")
	}
	assert(nodes.len > 0)
}

fn test_get_nodes_dev() {
	mut gp := get(.dev, false)
	nodes := gp.get_nodes() or {
		panic("Failed to get nodes")
	}
	assert(nodes.len > 0)
}

fn test_get_nodes_test() {
	mut gp := get(.test, false)
	nodes := gp.get_nodes() or {
		panic("Failed to get nodes")
	}
	assert(nodes.len > 0)
}

fn test_get_nodes_main() {
	mut gp := get(.main, false)
	nodes := gp.get_nodes() or {
		panic("Failed to get nodes")
	}
	assert(nodes.len > 0)
}

fn test_get_gateways_qa() {
	mut gp := get(.qa, false)
	nodes := gp.get_gateways() or {
		panic("Failed to get gateways")
	}
	assert(nodes.len > 0)
}

fn test_get_gateways_dev() {
	mut gp := get(.dev, false)
	nodes := gp.get_gateways() or {
		panic("Failed to get gateways")
	}
	assert(nodes.len > 0)
}

fn test_get_gateways_test() {
	mut gp := get(.test, false)
	nodes := gp.get_gateways() or {
		panic("Failed to get gateways")
	}
	assert(nodes.len > 0)
}

fn test_get_gateways_main() {
	mut gp := get(.main, false)
	nodes := gp.get_gateways() or {
		panic("Failed to get gateways")
	}
	assert(nodes.len > 0)
}

fn test_get_twins_qa() {
	mut gp := get(.qa, false)
	twins := gp.get_twins() or {
		panic("Failed to get twins")
	}
	assert(twins.len > 0)
}

fn test_get_twins_dev() {
	mut gp := get(.dev, false)
	twins := gp.get_twins() or {
		panic("Failed to get twins")
	}
	assert(twins.len > 0)
}

fn test_get_twins_test() {
	mut gp := get(.test, false)
	twins := gp.get_twins() or {
		panic("Failed to get twins")
	}
	assert(twins.len > 0)
}

/* fn test_get_twins_main() {
	mut gp := get(.main, false)
	twins := gp.get_twins() or {
		panic("Failed to get twins")
	}
	assert(twins.len > 0)
} */

fn test_get_stats_qa() {
	mut gp := get(.qa, false)
	stats := gp.get_stats() or {
		panic("Failed to get stats")
	}
	assert(stats.nodes > 0)
}

fn test_get_stats_dev() {
	mut gp := get(.dev, false)
	stats := gp.get_stats() or {
		panic("Failed to get stats")
	}
	assert(stats.nodes > 0)
}

fn test_get_stats_test() {
	mut gp := get(.test, false)
	stats := gp.get_stats() or {
		panic("Failed to get stats")
	}
	assert(stats.nodes > 0)
}

fn test_get_stats_main() {
	mut gp := get(.test, false)
	stats := gp.get_stats() or {
		panic("Failed to get stats")
	}
	assert(stats.nodes > 0)
}

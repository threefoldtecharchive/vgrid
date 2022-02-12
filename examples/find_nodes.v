module main

import threefoldtech.vgrid.explorer
import threefoldtech.vgrid.gridproxy

fn do()? {

	mut explorer := explorer.get(.test)

	// ns := explorer.nodes_find(mem_min_gb:50,hdd_min_gb:1000,public_ip:true)?
	// ns := explorer.nodes_find(mem_min_gb:50,public_ip:true)?
	// ns := explorer.nodes_find(public_ip:true,country:"belgium")?
	// ns := explorer.nodes_find(public_ip:true,region:.europe_west)?

	// ns := explorer.node_find(public_ip:true,region:.europe_west)?

	//next will give a random node because is region world
	ns := explorer.node_find(region:.world)?

	//today we only have region:.europe_west and world defined (and even very rough)
	// ns := explorer.nodes_find(region:.europe_west)?
	println(ns)

}

fn main() {
	//main loop, just call our main method & panic if issues
	do() or {panic(err)}
}

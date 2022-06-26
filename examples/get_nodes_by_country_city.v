import threefoldtech.vgrid.gridproxy
import threefoldtech.vgrid.gridproxy.model {NodesFilter}
import os


fn main(){
	//Default value used in intializing the resources
	mut nodes_filter := NodesFilter {}

	if "--help" in os.args {
		println("This script to get nodes by city or country or both \n
		--city 		name of the city  (optional) \n
		--country 	name of the country (optional) ")
		return
	}

	if "--city" in os.args {
		index_val:=os.args.index("--city")
		nodes_filter.city = os.args[index_val+1]

	}

	if "--country" in os.args {
		mut index_val:=os.args.index("--country")
		nodes_filter.country = os.args[index_val+1]

	}

	mut gp_client := gridproxy.get(.test, true)
	nodes_by_city_country := gp_client.get_nodes(nodes_filter) or {
		println("got an error while getting nodes")
		println("error message : ${err.msg()}")
		println("error code : ${err.code()}")
		return
	}
	println("found $nodes_by_city_country.len nodes in country: $nodes_filter.country and city: $nodes_filter.city")
	println("---------------------------------------")
	println(nodes_by_city_country)
}

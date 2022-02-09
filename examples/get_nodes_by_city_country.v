import threefoldtech.vgrid.explorer
import os

fn get_nodes_by_city_country(geo_location explorer.GeoLocation) ? {
	mut explorer_con := explorer.get(.test)
	mut nodes_by_country_city := explorer_con.nodes_by_country_city(geo_location)?
	println(nodes_by_country_city)
}

fn main(){
	mut explorer_con := explorer.get(.test)
	mut geo_location := explorer.GeoLocation{}
	mut city_name := ""
	mut country_name := "Belgium"


	mut explorer := explorer.get(.test)
	

	cl := explorer_con.countries_list()?
	println(cl)

	if "--help" in os.args {
		println("This method to get nodes by city or country or both \n
		--city 		name of the city  (optional) \n
		--country 	name of the country (optional) ")
		return
	}

	if "--city" in os.args {
		mut index_val:=os.args.index("--city")
		city_name = os.args[index_val+1]
		geo_location.city_name = city_name


	}

	if "--country" in os.args {
		mut index_val:=os.args.index("--country")
		country_name = os.args[index_val+1]
		geo_location.country_name = country_name

	}

	if city_name == "" && country_name == ""{
		println("Please specify a city or country name")
		return
	}

	get_nodes_by_city_country(geo_location) or {return }
}

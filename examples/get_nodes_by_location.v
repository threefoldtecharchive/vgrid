import explorer
import os 
fn get_nodes_by_location(latitude string,longitude string) ? {
	mut explorer := explorer.get(.test)
	mut nodes_by_location := explorer.nodes_by_location(latitude,longitude)?
	println(nodes_by_location)
}
fn main(){
	//TODO: how is this supposed to work?, shouldn't it be an area?
	mut latitude:="16"
	mut longitude:="48"
	if "--help" in os.args {
		println("This method to get nodes by location including latitude and longitude \n
		--latitude value (required) \n
		--longitude value (required) ")
		return
	}
	if "--latitude" in os.args {
		mut index_val:=os.args.index("--latitude")
		latitude = os.args[index_val+1]

	}
	if "--longitude" in os.args {
		mut index_val:=os.args.index("--longitude")
		longitude = os.args[index_val+1]

	}
	get_nodes_by_location(latitude,longitude) or {return }

}
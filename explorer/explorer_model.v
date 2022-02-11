module explorer

// TFGridEntity represents an entity in the threefold grid database
// an entity is linked to a physical person
pub struct TFGridEntity {
pub:	
	grid_version u32    [json: gridVersion]
	id           u32    [json: entityId]
	name         string [json: name]
	country      string [json: country]
	city         string [json: city]
}

// TFGridTwin represents a digital copy of a user
pub struct TFGridTwin {
pub:
	grid_version u32    [json: gridVersion]
	twin_id      u32    [json: twinId]
	// ip is where the digital twin is reachable
	// can be ipv4 / ipv6
	ip           string [json: ip]
	// substrate ed25519 ss58 address
	id           string [json: id]
}

// TFGridNode represents a Threefold node in the threefold grid database
pub struct TFGridNode {
pub:	
	grid_version u32   [json: gridVersion]
	id           u32      [json: nodeId]
	farm_id      u32      [json: farmId]
	twin_id      u32      [json: twinId]
	country      string   [json: country]
	city         string   [json: city]
	location     Location [json: location]
	hru          string
	sru          string
	cru          string
	mru          string
	public_config PublicConfig [json: publicConfig]
}

pub struct PublicConfig {
pub:	
	ipv4 string
	ipv6 string
	gw4 string
	gw6 string
}

pub struct Location {
pub:	
	longitude string
	latitude  string
}

// TFGridFarmer represents a farmer in the threefold grid database
pub struct TFGridFarmer {
pub:
	grid_version      u32    [json: gridVersion]
	id                u32    [json: farmId]
	// link to digital twin farmer
	twin_id           u32    [json: twinId]
	name              string
	// country           string [json: country]
	// city              string [json: city]
	// id of the pricing policy that this farmer has acquired
	pricing_policy_id u32    [json: pricingPolicyId]
	// cerfication type of the farmer
	certification_type string [json: certificationType]
}

// Todo: hook up public ips 
pub struct PublicIP {
pub:	
	farm_id           u32    [json: farmID]
	ip				  string
	contract_id		  u32
}

pub struct Country {
pub mut:
	id   string [json: id]
	name string [json: name]
	code string [json: code]
}

pub struct City {
pub:
	id   string [json: id]
	name string [json: name]
	code string [json: code]
}

pub struct PricingPolicy {
pub:	
	grid_version      u32    [json: gridVersion]
	id				  u32	 [json:pricingPolicyID]
	name			  string [json:name]
	currency          string
	su                u32
	cu			      u32
	nu                u32
}

pub struct GeoLocation{
pub mut:
	city_name string
	country_name string
}

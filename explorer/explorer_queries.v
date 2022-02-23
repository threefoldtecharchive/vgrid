module explorer


pub fn (mut explorer ExplorerConnection) entity_list() ?[]TFGridEntity {
	data := explorer.query(
			query: '{ entities { name, entityId, name, gridVersion, country, city } }'
			operation: 'getAll'
		) or {
			eprintln(err)
			return []TFGridEntity{}
	}
	return data.data.entities
}

pub fn (mut explorer ExplorerConnection) entity_by_id(id u32) ?TFGridEntity {

	data := explorer.query(
			query: '{ entities(where: {entityId_eq: $id }) { name, entityId, name, gridVersion, country, city } }'
			operation: 'getOne'
		)?

	if data.data.entities.len > 0 {
		return data.data.entities[0]
	} else {
		return error('no entity found for id: $id')
	}
}

pub fn (mut explorer ExplorerConnection) twin_list() ?[]TFGridTwin {
	data := explorer.query(
			query: '{ twins { twinId, ip, gridVersion, id } }'
			operation: 'getAll'
		)?
	return data.data.twins
}

pub fn (mut explorer ExplorerConnection) twin_by_id(id u32) ?TFGridTwin {
	data := explorer.query(
			query: '{ twins(where: {twinId_eq: $id }) { twinId, ip, gridVersion, id } }'
			operation: 'getOne'
		)?
	if data.data.twins.len > 0 {
		return data.data.twins[0]
	} else {
		return error('no twin found with id: $id')
	}
}

pub fn (mut explorer ExplorerConnection) nodes_list() ?[]TFGridNode {
	data := explorer.query(
			query: '{ nodes(orderBy: nodeId_ASC, limit: 5000) { gridVersion, nodeId, farmId, twinId, country, city, sru, cru, hru, mru, location{ latitude, longitude }, publicConfig { ipv4, ipv6, gw4, gw6 } } }'
			operation: 'getAll'
			cache: false
		)?
	return data.data.nodes
}

pub fn (mut explorer ExplorerConnection) node_by_id(id u32) ?TFGridNode {
	data := explorer.query(
			query: '{ nodes(where: { nodeId_eq: $id }) { 
					gridVersion, nodeId, farmId, twinId, country, city, sru, cru, hru, mru, 
					location{ latitude, longitude }, 
					publicConfig { ipv4, ipv6, gw4, gw6 } 
					} }
				'
			operation: 'getOne'
		)?
	if data.data.nodes.len > 0 {
		return data.data.nodes[0]
	} else {
		return error ('no node found for id:$id')
	}
}

pub fn (mut explorer ExplorerConnection) nodes_by_resources(sru u64, cru u64, hru u64, mru u64) ?[]TFGridNode {
	data := explorer.query(
			query: '{ nodes(where: { sru_gt: $sru, cru_gt: $cru, hru_gt: $hru, mru_gt: $mru }) { gridVersion, nodeId, farmId, twinId, country, city, sru, cru, hru, mru, location{ latitude, longitude }, publicConfig { ipv4, ipv6, gw4, gw6 } } }'
			operation: 'getAll'
		) ?
	return data.data.nodes
}

pub fn (mut explorer ExplorerConnection) nodes_by_location(latitude string, longitude string) ?[]TFGridNode {

	data := explorer.query(
			query: '{ nodes(where: {location: { latitude_eq: "$latitude", longitude_eq: "$longitude" }}) { gridVersion, nodeId, farmId, twinId, country, city, sru, cru, hru, mru, location{ latitude, longitude }, publicConfig { ipv4, ipv6, gw4, gw6 } } }'
			operation: 'getAll'
		)?
	return data.data.nodes
}
pub fn (mut explorer ExplorerConnection) nodes_by_country_city(geoLocation GeoLocation) ?[]TFGridNode {
	mut sub_query:=""

	if geoLocation.city_name != "" {
		sub_query += 'city_eq: "$geoLocation.city_name",'
	}

	if geoLocation.country_name != "" {
		sub_query += 'country_eq: "$geoLocation.country_name",'
	}

	data := explorer.query(
			query: '{ nodes(where: {$sub_query}) { gridVersion, nodeId, farmId, twinId, country, city, sru, cru, hru, mru, location{ latitude, longitude }, publicConfig { ipv4, ipv6, gw4, gw6 }, id } }'
			operation: 'getAll'
		) ?
	return data.data.nodes
}

pub fn (mut explorer ExplorerConnection) farms_list() ?[]TFGridFarmer {
	data := explorer.query(
			query: '
			{
				farms {
					gridVersion
					farmId
					name
					certificationType
				}
			}
			'
			operation: 'getAll'
		)?
	return data.data.farms
}

pub fn (mut explorer ExplorerConnection) farm_by_id(id u32) ?TFGridFarmer {
	data := explorer.query(
			query: '{ farms(where: { farmId_eq: $id }) { gridVersion, farmId, twinId, name, country, city, pricingPolicyId, certificationType } }'
			operation: 'getOne'
		)?
	if data.data.farms.len > 0 {
		return data.data.farms[0]
	} else {
		return error('no farm found for id:$id')
	}
}

pub fn (mut explorer ExplorerConnection) countries_list() ?[]Country {
	data := explorer.query(
			query: '{ countries(limit: 10000) { name, code } }'
			operation: 'getAll'
		)?
	return data.data.countries
}

pub fn (mut explorer ExplorerConnection) countries_by_name_substring(substring string) ?[]Country {
	data := explorer.query(
			query: '{ countries(where: { name_contains: "$substring" }) { name, code } }'
			operation: 'getAll'
		)?
	return data.data.countries
}
pub fn (mut explorer ExplorerConnection) country_by_name(name string) ?Country {
	data := explorer.query(
			query: '{ countries(where: { name_eq: "$name" }) { name, code, id } }'
			operation: 'getOne'
		)?
	if data.data.countries.len > 0 {
		return data.data.countries[0]
	} else {
		return error('no country found with $name name')
	}
}

pub fn (mut explorer ExplorerConnection) country_by_id(id u32) ?Country {
	data := explorer.query(
			query: '{ countries(where: { id_eq: $id }) { name, code } }'
			operation: 'getAll'
		)?

	if data.data.countries.len > 0 {
		return data.data.countries[0]
	} else {
		return error('no country found with countryid:$id')
	}
}

pub fn (mut explorer ExplorerConnection) cities_list() ?[]City {
	data := explorer.query(
			query: '{ cities(limit: 10000) { name, country } }'
			operation: 'getAll'
		)?
	return data.data.cities
}

pub fn (mut explorer ExplorerConnection) cities_by_name_substring(substring string) ?[]City {
	data := explorer.query(
			query: '{ cities(where: { name_contains: "$substring" }) { name, country } }'
			operation: 'getAll'
		)?
	return data.data.cities
}
pub fn (mut explorer ExplorerConnection) city_by_name(name string) ?City {
	data := explorer.query(
			query: '{ cities(where: { name_eq: "$name" }) { name, country, id } }'
			operation: 'getOne'
		)?
	if data.data.cities.len > 0 {
		return data.data.cities[0]
	} else {
		return error('no city found with $name name')
	}
}

pub fn (mut explorer ExplorerConnection) city_by_id(id u32) ?City {

	data := explorer.query(
			query: '{ cities(where: { id_eq: $id }) { name, country } }'
			operation: 'getAll'
		)?
	if data.data.cities.len > 0 {
		return data.data.cities[0]
	} else {
		return error('no city found with id:$id')
	}
}

pub fn (mut explorer ExplorerConnection) cities_by_country_id(country_id u32) ?[]City {

	data := explorer.query(
			query: '{ cities(where: { country_eq: $country_id }) { name, country } }'
			operation: 'getAll'
		)?
	return data.data.cities
}


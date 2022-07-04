module model
pub type NodeGetter = fn (NodeFilter) ?[]Node

pub struct NodeIterator {
pub mut:
	filter		 	NodeFilter
pub:
	get_func		 NodeGetter
}

pub fn (mut i NodeIterator) next() ?[]Node {
	match i.filter.page {
		EmptyOption {
			i.filter.page = u64(1)
		}
		u64 {
			i.filter.page = i.filter.page as u64 + 1
		}
	} 
	nodes := i.get_func(i.filter) or {
		return err
	}
	if nodes.len == 0 {
		return none
	}
	return nodes
}

pub type FarmGetter = fn (FarmFilter) ?[]Farm

pub struct FarmIterator {
pub mut:
	filter		 	FarmFilter
pub:
	get_func		 FarmGetter
}

pub fn (mut i FarmIterator) next() ?[]Farm {
	match i.filter.page {
		EmptyOption {
			i.filter.page = u64(1)
		}
		u64 {
			i.filter.page = i.filter.page as u64 + 1
		}
	} 
	farms := i.get_func(i.filter) or {
		return err
	}
	if farms.len == 0 {
		return none
	}
	return farms
}

pub type ContractGetter = fn (ContractFilter) ?[]Contract

pub struct ContractIterator {
pub mut:
	filter		 	ContractFilter
pub:
	get_func		 ContractGetter
}

pub fn (mut i ContractIterator) next() ?[]Contract {
	match i.filter.page {
		EmptyOption {
			i.filter.page = u64(1)
		}
		u64 {
			i.filter.page = i.filter.page as u64 + 1
		}
	} 
	contracts := i.get_func(i.filter) or {
		return err
	}
	if contracts.len == 0 {
		return none
	}
	return contracts
}

pub type TwinGetter = fn (TwinFilter) ?[]Twin

pub struct TwinIterator {
pub mut:
	filter		 	TwinFilter
pub:
	get_func		 TwinGetter
}

pub fn (mut i TwinIterator) next() ?[]Twin {
	match i.filter.page {
		EmptyOption {
			i.filter.page = u64(1)
		}
		u64 {
			i.filter.page = i.filter.page as u64 + 1
		}
	} 
	twins := i.get_func(i.filter) or {
		return err
	}
	if twins.len == 0 {
		return none
	}
	return twins
}


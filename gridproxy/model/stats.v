module model

pub enum NodeStatus {
	all
	online
}

[params]
pub struct StatsParams {
pub:
	status NodeStatus
}

pub struct GridStats {
pub:
	nodes              u32
	farms              u32
	countries          u32
	total_cru          u32            [json: totalCru]
	total_sru          ByteUnit       [json: totalSru]
	total_mru          ByteUnit       [json: totalMru]
	total_hru          ByteUnit       [json: totalHru]
	public_ips         u32            [json: publicIps]
	access_nodes       u32            [json: accessNodes]
	gateways           u32
	twins              u32
	contracts          u32
	nodes_distribution map[string]u32 [json: nodesDistribution]
}

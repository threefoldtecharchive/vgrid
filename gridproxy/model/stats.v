module model

pub enum NodeStatus {
	all
	online
}

[params]
pub struct StatsParams {
	pub:
		status		NodeStatus
}

pub struct GridStats {
	pub:
		nodes              i64
		farms              i64
		countries          i64
		total_cru          i64            [json: totalCru]
		total_sru          ByteUnit       [json: totalSru]
		total_mru          ByteUnit       [json: totalMru]
		total_hru          ByteUnit       [json: totalHru]
		public_ips         i64            [json: publicIps]
		access_nodes       i64            [json: accessNodes]
		gateways           i64
		twins              i64
		contracts          i64
		nodes_distribution map[string]i64 [json: nodesDistribution]
}

module model

pub struct Twin {
	pub:
		twin_id    i64    [json: twinId]
		account_id string [json: accountId]
		ip         string
}

[params]
pub struct TwinParams {
	page       i64 | EmptyOption = EmptyOption{}
	size       i64 | EmptyOption = EmptyOption{}
	ret_count  string
	twin_id    i64 | EmptyOption = EmptyOption{}
	account_id string
}

pub fn (p &TwinParams) to_map() map[string]string {
	mut m := map[string]string{}
	match p.page {
		EmptyOption {}
		i64 {
			m['pages'] = p.page.str()
		}
	}
	match p.size {
		EmptyOption {}
		i64 {
			m['size'] = p.size.str()
		}
	}
	if p.ret_count != '' {
		m['ret_count'] = p.ret_count
	}
	match p.twin_id {
		EmptyOption {}
		i64 {
			m['twin_id'] = p.twin_id.str()
		}
	}
	if p.account_id != '' {
		m['account_id'] = p.account_id
	}
	return m
}

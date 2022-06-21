module model

pub struct Twin {
pub:
	twin_id    u32    [json: twinId]
	account_id string [json: accountId]
	ip         string
}

[params]
pub struct TwinParams {
	page       u32 | EmptyOption = EmptyOption{}
	size       u32 | EmptyOption = EmptyOption{}
	ret_count  string
	twin_id    u32 | EmptyOption = EmptyOption{}
	account_id string
}

pub fn (p &TwinParams) to_map() map[string]string {
	mut m := map[string]string{}
	match p.page {
		EmptyOption {}
		u32 {
			m['pages'] = p.page.str()
		}
	}
	match p.size {
		EmptyOption {}
		u32 {
			m['size'] = p.size.str()
		}
	}
	if p.ret_count != '' {
		m['ret_count'] = p.ret_count
	}
	match p.twin_id {
		EmptyOption {}
		u32 {
			m['twin_id'] = p.twin_id.str()
		}
	}
	if p.account_id != '' {
		m['account_id'] = p.account_id
	}
	return m
}

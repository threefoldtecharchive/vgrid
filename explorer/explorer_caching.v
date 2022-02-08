module explorer

import crypto.md5
// calculate the key for the cache starting from data and prefix

fn cache_key(prefix string, postdata string) string {
	/*
	Create Cache Key
	Inputs:
		prefix: GraphQL elements types, ex (projects, issues, tasks, ...).

	Output:
		cache_key: key that will be used in redis
	*/
	mut data2 := postdata
	if data2.len > 16 {
		data2 = md5.hexhash(data2)
	}
	if data2.len > 0 {
		return 'explorer:' + prefix + ':' + data2
	}
	return 'explorer:' + prefix
}

fn (mut h ExplorerConnection) cache_get(prefix string, postdata string, cache bool) string {
	/*
	Get from Cache
	Inputs:
		prefix: a prefix can be everything
		reqdata: data used in the request.
		cache: Flag to enable caching.
	Output:
		result: If cache ture and no thing stored or cache false will return empty string
	*/
	mut text := ''
	if cache {
		text = h.redis.get(cache_key(prefix, postdata)) or { '' }
	}
	return text
}

fn (mut h ExplorerConnection) cache_set(prefix string, postdata string, data string, cache bool) ? {
	/*
	Set Cache
	Inputs:
		prefix: a prefix can be everything
		reqdata: data used in the request.
		data: Json encoded data.
		cache: Flag to enable caching.
	*/
	if cache {
		key := cache_key(prefix, postdata)
		h.redis.set(key, data) ?
		h.redis.expire(key, h.cache_timeout) or {
			panic('should never get here, if redis worked expire should also work.$err')
		}
	}
}

pub fn (mut h ExplorerConnection) cache_drop_all() ? {
	/*
	Drop all cache related to explorer
	*/
	all_keys := h.redis.keys('explorer:*') ?
	for key in all_keys {
		h.redis.del(key) ?
	}
}

pub fn (mut h ExplorerConnection) cache_drop(prefix string) ? {
	/*
	Drop specific key cache related to explorer
	*/
	all_keys := h.redis.keys('explorer:$prefix*') ?
	for key in all_keys {
		h.redis.del(key) ?
	}
}

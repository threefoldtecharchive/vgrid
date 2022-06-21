module model

import time { Time }

type ByteUnit = u32

pub fn (u ByteUnit) to_megabytes() f64 {
	return f64(u) / 1e+6
}

pub fn (u ByteUnit) to_gigabytes() f64 {
	return f64(u) / 1e+9
}

pub fn (u ByteUnit) to_terabytes() f64 {
	return f64(u) / 1e+12
}

type SecondUnit = u32

pub fn (u SecondUnit) to_minutes() f64 {
	return f64(u) / 60
}

pub fn (u SecondUnit) to_hours() f64 {
	return f64(u) / (60 * 60)
}

pub fn (u SecondUnit) to_days() f64 {
	return f64(u) / (60 * 60 * 24)
}

type UnixTime = u32

pub fn (t UnixTime) to_time() Time {
	return time.unix(t)
}

struct EmptyOption {}

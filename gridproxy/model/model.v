module model

import time { Time }
import math { pow10 }

type ByteUnit = u64

pub fn (u ByteUnit) to_megabytes() f64 {
	return f64(u) / 1e+6
}

pub fn (u ByteUnit) to_gigabytes() f64 {
	return f64(u) / 1e+9
}

pub fn (u ByteUnit) to_terabytes() f64 {
	return f64(u) / 1e+12
}

type SecondUnit = u64

pub fn (u SecondUnit) to_minutes() f64 {
	return f64(u) / 60
}

pub fn (u SecondUnit) to_hours() f64 {
	return f64(u) / (60 * 60)
}

pub fn (u SecondUnit) to_days() f64 {
	return f64(u) / (60 * 60 * 24)
}

type UnixTime = u64

pub fn (t UnixTime) to_time() Time {
	return time.unix(t)
}

type TFTUnit = u64

pub fn (t TFTUnit) to_utft() f64 {
	return f64(t) / 10.0
}

pub fn (t TFTUnit) to_mtft() f64 {
	return f64(t) / pow10(4)
}

pub fn (t TFTUnit) to_tft() f64 {
	return f64(t) / pow10(7)
}

struct EmptyOption {}

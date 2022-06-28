module model

import time { Time }
import math { pow10, floor }

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

pub fn (u ByteUnit) str() string {
	if u > 1e+12 {
		return '${u.to_terabytes():.2} TB'
	} else if u > 1e+9 {
		return '${u.to_gigabytes():.2} GB'
	} else if u > 1e+6 {
		return '${u.to_megabytes():.2} MB'
	}
	return '${u64(u)} Bytes'

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

pub fn (u SecondUnit) str() string {
	sec_num := u64(u)
	d := math.floor(sec_num/86400)
    h := math.fmod(math.floor(sec_num/3600), 24)
    m := math.fmod(math.floor(sec_num/60), 60)
    s := sec_num % 60
	mut str := ''
	if d > 0 {
		str += '$d days '
	}
	if h > 0 {
		str += '$h hours '
	}
	if m > 0 {
		str += '$m minutes '
	}
	if s > 0 {
		str += '$s seconds'
	}
	return str 	
}

type UnixTime = u64

pub fn (t UnixTime) to_time() Time {
	return time.unix(t)
}

pub fn (t UnixTime) str() string {
	return '${t.to_time().local()}'
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

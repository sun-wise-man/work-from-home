extends TextureProgress

var is_decreasing : = true
export (int) var start_dr = -4
export (int) var increase_dr_rate
export (int) var hour_per_increase
var hour_count : = 0
var decrease_rate : int

func _ready():
	decrease_rate = start_dr
	
func _on_World_hour_pass(time):
	if is_decreasing:
		value += decrease_rate
	hour_count += 1
	if hour_count == hour_per_increase:
		decrease_rate += increase_dr_rate
		hour_count = 0

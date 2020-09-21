extends ProgressBar

var is_decreasing : = true
export (int) var decreased_rate = -4


func _on_World_hour_pass(time):
	if is_decreasing:
		value += decreased_rate

extends TextureRect
var day_count : = 1

func _ready():
	show_time(get_parent().get_parent().starting_hour)

func _on_World_hour_pass(time):
	show_time(time)

func show_time(time):
	if time < 10:
		$hour.text = "0" + str(time) + ":00"
	else:
		$hour.text = str(time) + ":00"
	if time == 0:
		day_count += 1
		$day.text = "Day" + str(day_count)

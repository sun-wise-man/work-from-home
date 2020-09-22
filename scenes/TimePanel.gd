extends Panel
var day_count : = 1


func _on_World_hour_pass(time):
	if time < 10:
		$hour.text = "0" + str(time) + ":00"
	else:
		$hour.text = str(time) + ":00"
	if time == 0:
		day_count += 1
		$day.text = "Day" + str(day_count)

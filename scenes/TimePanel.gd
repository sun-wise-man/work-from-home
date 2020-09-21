extends Panel



func _on_World_hour_pass(time):
	if time < 10:
		$Label.text = "0" + str(time) + ":00"
	else:
		$Label.text = str(time) + ":00"

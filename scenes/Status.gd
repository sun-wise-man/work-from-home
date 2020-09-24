extends Label


func _on_Status_visibility_changed():
	if visible == true:
		yield(get_tree().create_timer(1.0), "timeout")
		visible = false

func get_gain_number(total):
	if total > 0:
		visible = true
		text = "+" + str(total)
	elif total < 0:
		visible = true
		text = str(total)

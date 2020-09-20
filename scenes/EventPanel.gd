extends Panel

export (float) var time_awake


func _on_EventPanel_visibility_changed():
	if visible == true:
		yield(get_tree().create_timer(time_awake), "timeout")
		visible = false

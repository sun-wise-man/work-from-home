extends Label


func _on_Status_visibility_changed():
	if visible == true:
		yield(get_tree().create_timer(1.0), "timeout")
		visible = false

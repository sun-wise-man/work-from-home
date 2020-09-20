extends Node

export (String) var activity_type
export (String) var activity_name
export (int) var activity_gain
export (String) var activity_desc


func _on_Area2D_mouse_entered():
	get_parent().get_activity_hover(activity_type, activity_name, activity_gain, activity_desc, true)


func _on_Area2D_mouse_exited():
	get_parent().get_activity_hover("null", "null", 0, "null", false)

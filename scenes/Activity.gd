extends Node

export (String) var activity_type
export (String) var activity_name
export (int) var activity_gain


func _on_Area2D_mouse_entered():
	get_parent().get_activity_hover(activity_type, activity_name, activity_gain)


func _on_Area2D_mouse_exited():
	get_parent().get_activity_hover("null", "null", 0)

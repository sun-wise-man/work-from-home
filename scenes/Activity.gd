extends Node

export (String) var activity_type
export (String) var activity_name
export (int) var activity_gain
export (String) var activity_desc

var world

func _ready():
	world = get_parent().get_parent()

func _on_Area2D_mouse_entered():
	world.get_activity_hover(activity_type, activity_name, activity_gain, activity_desc, true)


func _on_Area2D_mouse_exited():
	world.get_activity_hover("null", "null", 0, "null", false)

extends Node

export (String) var object_names
export (int) var object_level
export (int) var object_start_cost
export (int) var object_cost_increase

var world
var object_cost

func _ready():
	world = get_parent().get_parent()
	object_cost = object_start_cost

func _on_Area2D_mouse_entered():
	world.get_object_hover(object_names, object_level, object_cost)


func _on_Area2D_mouse_exited():
	world.get_object_hover("null", 0, 0)


func _on_ActivitySystem_upgrade_object(object_name, money):
	if object_name == object_names:
		if money >= object_cost:
			world.money -= object_cost
			object_level += 1
			object_cost += object_cost_increase
			world.reset_money()

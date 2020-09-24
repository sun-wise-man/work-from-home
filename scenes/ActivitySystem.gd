extends Control

export (PoolStringArray) var activity_name
export (PoolStringArray) var activity_from
export (PoolStringArray) var activity_type
export (PoolIntArray) var activity_gain
export (PoolIntArray) var activity_scale
export (PoolStringArray) var activity_desc
var activity_pool : PoolIntArray
var object_choice : String
var money : int
var object_cost : int
var world
var showing : bool = false
signal upgrade_object(object_name, money)

func _ready():
	world = get_parent().get_parent()

func _process(delta):
	money = world.money
	if showing:
		if money > object_cost:
			$Panel/Button3.disabled = false
		else:
			$Panel/Button3.disabled = true

func get_activity_pool(from):
	var new_pool : PoolIntArray = []
	for i in range(activity_name.size()):
		if activity_from[i] == from:
			new_pool.append(i)
	return new_pool

func showing_popup(object_level, cost, position):
	showing = true
	rect_position = position
	visible = true
	$Panel/Object.text = object_choice
	$Panel/Level.text = "Lv " + str(object_level)
	$Panel/Button/Label.text = activity_desc[activity_pool[0]]
	if activity_pool.size() == 2:
		$Panel/Button2.visible = true
		$Panel/Button2/Label.text = activity_desc[activity_pool[1]]
	else:
		$Panel/Button2.visible = false
	$Panel/Button3/Label.text = "Upgrade -" + str(cost) + "$"

func show_popup(object_name, object_level, cost, position):
	activity_pool = get_activity_pool(object_name)
	object_choice = object_name
	object_cost = cost
	showing_popup(object_level, cost, position)

func close_popup():
	visible = false

func _on_Button_pressed():
	visible = false
	showing = false
	world.get_activity(activity_name[activity_pool[0]], activity_type[activity_pool[0]], 
		activity_gain[activity_pool[0]], activity_scale[activity_pool[0]])
	world.inside_popup = false
	world.showing_popup = false


func _on_Button2_pressed():
	visible = false
	showing = false
	world.get_activity(activity_name[activity_pool[1]], activity_type[activity_pool[1]], 
		activity_gain[activity_pool[1]], activity_scale[activity_pool[1]])
	world.inside_popup = false
	world.showing_popup = false

func _on_Button3_pressed():
	visible = false
	showing = false
	emit_signal("upgrade_object", object_choice, money)
	world.inside_popup = false
	world.showing_popup = false

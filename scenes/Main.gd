extends Node2D


export (float) var seconds_per_hour = 10.0
signal hour_pass
var timer
var time_coroutine
var activity_hover : String
var activity_gain_hover : int
var activity_fix : String
var activity_gain_fix : int
var is_working : bool = false 

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			is_working = false
			reset_element_decrease()
			if activity_hover != "null":
				activity_fix = activity_hover
				activity_gain_fix = activity_gain_hover
			else:
				activity_fix = "null"
				activity_gain_fix = 0
			var path = $Navigation2D.get_simple_path($Player.position, event.position)
			$Player.take_path(path)
			$Line2D.points = path

func _ready():
	time_coroutine = time_moving()

func time_moving():
	while true:
		yield(get_tree().create_timer(seconds_per_hour), "timeout")
		emit_signal("hour_pass")

func get_activity_hover(activity_name, gain):
	activity_hover = activity_name
	activity_gain_hover = gain


func _on_Player_path_done():
	if activity_fix != "null":
		is_working = true


func _on_World_hour_pass():
	if is_working:
		if activity_fix == "Health":
			$HealthBar.value += activity_gain_fix
			$HealthBar.is_decreasing = false
		elif activity_fix == "Happiness":
			$HappinessBar.value += activity_gain_fix
			$HappinessBar.is_decreasing = false
		elif activity_fix == "Work":
			$WorkBar.value += activity_gain_fix
			$WorkBar.is_decreasing = false

func reset_element_decrease():
	$HealthBar.is_decreasing = true
	$HappinessBar.is_decreasing = true
	$WorkBar.is_decreasing = true

extends Node2D

signal hour_pass
var timer
var time_coroutine

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed:
			var path = $Navigation2D.get_simple_path($Player.position, event.position)
			$Player.take_path(path)
			$Line2D.points = path

func _ready():
	time_coroutine = time_moving()

func time_moving():
	while true:
		yield(get_tree().create_timer(10.0), "timeout")
		emit_signal("hour_pass")

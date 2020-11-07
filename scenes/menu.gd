extends Node2D


var playScene : bool = false
export (float) var speed = 60
var path : String


func _process(delta):
	if playScene:
		$Menu/Title.rect_position.y -= speed * delta
		$Menu/Highscore.rect_position.y += speed * delta
		$Menu/Start.rect_position.y += speed * delta
		if $Menu/Title.rect_position.y <= -170:
			get_tree().change_scene(path)


func _on_Start_pressed():
	playScene = true
	path = "res://scenes/main.tscn"
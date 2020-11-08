extends Node2D


var playScene : bool = false
export (float) var speed = 60


func _process(delta):
	if playScene:
		$Menu/Title.rect_position.y -= speed * delta
		$Menu/Highscore.rect_position.y += speed * delta
		$Menu/Start.rect_position.y += speed * delta
		$Menu/Tutorial.rect_position.y += speed * delta
		$Menu/Credit.rect_position.y += speed * delta
		if $Menu/Title.rect_position.y <= -170:
			get_tree().change_scene("res://scenes/main.tscn")


func _on_Start_pressed():
	playScene = true
	Global.tutorial = false


func _on_Highscore_pressed():
	$Menu/HSPanel.visible = true
	$Menu/HSPanel.show_data()



func _on_ExitHS_pressed():
	$Menu/HSPanel.visible = false


func _on_Tutorial_pressed():
	playScene = true
	Global.tutorial = true

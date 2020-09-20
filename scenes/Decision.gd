extends Panel


func _on_Option1_pressed():
	get_parent().decision_get(0)
	get_parent().unpause_game()
	visible = false


func _on_Option2_pressed():
	get_parent().decision_get(1)
	get_parent().unpause_game()
	visible = false

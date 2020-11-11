extends Panel


func _process(delta):
	if visible:
		rect_position = get_global_mouse_position()


func _on_HappinessBuff_mouse_entered():
	visible = true
	$Label.text = "bonus money"


func _on_HappinessBuff_mouse_exited():
	visible = false

func _on_HappinessDebuff_mouse_entered():
	visible = true
	$Label.text = "speed down"


func _on_HappinessDebuff_mouse_exited():
	visible = false


func _on_HealthBuff_mouse_entered():
	visible = true
	$Label.text = "speed up"


func _on_HealthBuff_mouse_exited():
	visible = false


func _on_HealthDebuff_mouse_entered():
	visible = true
	$Label.text = "dark screen"


func _on_HealthDebuff_mouse_exited():
	visible = false

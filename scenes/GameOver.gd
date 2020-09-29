extends Panel


export (String) var health_lose_text
export (String) var happiness_lose_text

func game_over(index, day, money):
	visible = true
	if index == 1:
		$Panel/HealthLose.visible = true
		$Panel/HappinessLose.visible = false
		$Panel/RichTextLabel.text = health_lose_text
	else:
		$Panel/HealthLose.visible = false
		$Panel/HappinessLose.visible = true
		$Panel/RichTextLabel.text = happiness_lose_text
	$Panel/Survive.text = "Survive for : " + str(day) + " days"
	$Panel/Earning.text = "Total earning : " + str(money) + "$"


func _on_Button_pressed():
	get_tree().reload_current_scene()

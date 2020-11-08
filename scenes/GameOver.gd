extends Panel

const FILE_NAME = "user://game-data.json"

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
	save_data(day, money)
	


func _on_Button_pressed():
	get_tree().reload_current_scene()
	

func save_data(day_survived, money):
	var score_data = {
		"DS1" : 0,
		"Money1" : 0,
		"Date1" : "N/A",
		"DS2" : 0,
		"Money2" : 0,
		"Date2" : "N/A",
		"DS3" : 0,
		"Money3" : 0,
		"Date3" : "N/A",
		"DS4" : 0,
		"Money4" : 0,
		"Date4" : "N/A",
		"DS5" : 0,
		"Money5" : 0,
		"Date5" : "N/A",
	}
	var file = File.new()
	if file.file_exists(FILE_NAME):
		file.open(FILE_NAME, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		if typeof(data) == TYPE_DICTIONARY:
			score_data = data
	var ds_value = day_survived
	var money_value = money
	var date_now = OS.get_date()
	var date_value = str(date_now["day"]) + "-" + str(date_now["month"])
	for i in range(5):
		var j = i + 1
		var ds_key = "DS" + str(j)
		var money_key = "Money" + str(j)
		var date_key = "Date" + str(j)
		if ds_value > score_data[ds_key] or (ds_value == score_data[ds_key]
		and money_value > score_data[money_key]):
			var ds_value_temp = score_data[ds_key]
			var money_value_temp = score_data[money_key]
			var date_value_temp = score_data[date_key]
			score_data[ds_key] = ds_value
			score_data[money_key] = money_value
			score_data[date_key] = date_value
			ds_value = ds_value_temp
			money_value = money_value_temp
			date_value = date_value_temp
	file.open(FILE_NAME, File.WRITE)
	file.store_string(to_json(score_data))
	file.close()


func _on_Home_pressed():
	get_tree().change_scene("res://scenes/menu.tscn")

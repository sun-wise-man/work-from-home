extends Node

const FILE_NAME = "user://game-data.json"

func show_data():
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
	$DS1.text = str(score_data["DS1"])
	$Money1.text = "$" + str(score_data["Money1"])
	$Date1.text = score_data["Date1"]
	$DS2.text = str(score_data["DS2"])
	$Money2.text = "$" + str(score_data["Money2"])
	$Date2.text = score_data["Date2"]
	$DS3.text = str(score_data["DS3"])
	$Money3.text = "$" + str(score_data["Money3"])
	$Date3.text = score_data["Date3"]
	$DS4.text = str(score_data["DS4"])
	$Money4.text = "$" + str(score_data["Money4"])
	$Date4.text = score_data["Date4"]
	$DS5.text = str(score_data["DS5"])
	$Money5.text = "$" + str(score_data["Money5"])
	$Date5.text = score_data["Date5"]
	

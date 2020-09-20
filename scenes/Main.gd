extends Node2D


export (float) var seconds_per_hour = 10.0
signal hour_pass
signal unpause
var timer
var time_coroutine
var activity_hover : String
var activity_name_hover : String
var activity_gain_hover : int
var activity_fix : String
var activity_name_fix : String
var activity_gain_fix : int
var is_working : bool = false 
var event_chance_pool : PoolIntArray
var decision_index : PoolIntArray
var is_pause : bool = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and not is_pause:
			is_working = false
			reset_element_decrease()
			if activity_hover != "null":
				activity_fix = activity_hover
				activity_name_fix = activity_name_hover
				activity_gain_fix = activity_gain_hover
			else:
				activity_fix = "null"
				activity_name_fix = "null"
				activity_gain_fix = 0
				event_chance_pool = []
				decision_index = []
			var path = $Navigation2D.get_simple_path($Player.position, event.position)
			$Player.take_path(path)
			$Line2D.points = path

func _ready():
	time_coroutine = time_moving()

func _process(delta):
	$Tooltip.rect_position = get_viewport().get_mouse_position()

func pause_game():
	is_pause = true

func unpause_game():
	is_pause = false
	emit_signal("unpause")

func time_moving():
	while true:
		if is_pause:
			yield(self, "unpause")
		yield(get_tree().create_timer(seconds_per_hour), "timeout")
		emit_signal("hour_pass")

func get_activity_hover(activity_type, activity_name, gain, activity_desc, enter):
	activity_hover = activity_type
	activity_name_hover = activity_name
	activity_gain_hover = gain
	if enter:
		$Tooltip/Label.text = activity_desc
		$Tooltip.visible = true
	else:
		$Tooltip.visible = false


func _on_Player_path_done():
	if activity_fix != "null":
		is_working = true
		event_chance_pool = $EventSystem.get_chance(activity_name_fix)


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
		if event_chance_pool != null:
			grab_event(event_chance_pool)

func reset_element_decrease():
	$HealthBar.is_decreasing = true
	$HappinessBar.is_decreasing = true
	$WorkBar.is_decreasing = true

func grab_event(pool : PoolIntArray):
	var number = randi() % 100
	print(number)
	var output : String
	if pool[number] != -1:
		output = $EventSystem.get_event_output(pool[number])
		if output == "gain":
			gain_event(pool[number])
		elif output == "chance":
			chance_event(pool[number])
		elif output == "decision":
			decision_event(pool[number])

func gain_event(index : int):
	var gain_value = $EventSystem.get_event_gain(index)
	var gain_desc = $EventSystem.get_event_desc(index)
	$HealthBar.value += gain_value[0]
	$HappinessBar.value += gain_value[1]
	$WorkBar.value += gain_value[2]
	$EventPanel/Label.text = gain_desc
	$EventPanel.visible = true
	
func chance_event(index : int):
	var new_pool = $EventSystem.get_chance($EventSystem.get_event_name(index))
	if new_pool[0] == -2:
		var number = randi() % 100
		if number <= $HappinessBar.value:
			gain_event(index)
		else:
			gain_event(index + 1)
	else:
		grab_event(new_pool)

func decision_event(index : int):
	var new_pool = $EventSystem.get_chance($EventSystem.get_event_name(index))
	decision_index = [new_pool[0], new_pool[50]]
	var question = $EventSystem.get_event_desc(index)
	var option1 = $EventSystem.get_event_name(new_pool[0])
	var option2 = $EventSystem.get_event_name(new_pool[50])
	$DecisionPanel.visible = true
	$DecisionPanel/Text.text = question
	$DecisionPanel/Option1/Label.text = option1
	$DecisionPanel/Option2/Label.text = option2
	pause_game()
	
func decision_get(index):
	var output_index = decision_index[index]
	var output = $EventSystem.get_event_output(output_index)
	if output == "gain":
		gain_event(output_index)
	elif output == "chance":
		chance_event(output_index)
	elif output == "decision":
		decision_event(output_index)

extends Node2D


export (float) var seconds_per_hour = 10.0
export (int) var starting_hour
signal hour_pass(time)
signal unpause
var time_hour : int
var timer
var time_coroutine
var object_hover : String = "null"
var object_level_hover : int
var object_cost_hover : int
var object_fix : String
var object_level_fix : int
var object_level_active : int
var object_cost_fix : int
var object_position : Vector2
var activity_name : String
var activity_type : String
var activity_gain : int
var activity_scale : int
var activity_from : String
var is_working : bool = false 
var event_chance_pool : PoolIntArray
var decision_index : PoolIntArray
var is_pause : bool = false
var day_count : = 1
var money : = 0
var health_gain_total : = 0
var happiness_gain_total : = 0
var work_gain_total : = 0
var showing_popup : bool = false
var inside_popup : bool = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and not is_pause:
			is_working = false
			reset_element_decrease()
			if object_hover != "null" and not showing_popup:
				object_fix = object_hover
				object_level_fix = object_level_hover
				object_cost_fix = object_cost_hover
				object_position = event.position
				showing_popup = true
				$GUI/ActivitySystem.show_popup(object_fix, object_level_fix, 
					object_cost_fix, object_position)
			elif not showing_popup:
				object_fix = "null"
				object_level_fix = 0
				object_cost_fix = 0
				activity_name = "null"
				activity_type = "null"
				activity_gain = 0
				activity_scale = 0
				event_chance_pool = []
				decision_index = []
				move_player(event.position)
			elif not inside_popup:
				object_fix = "null"
				object_level_fix = 0
				object_cost_fix = 0
				activity_name = "null"
				activity_type = "null"
				activity_gain = 0
				activity_scale = 0
				event_chance_pool = []
				decision_index = []
				$GUI/ActivitySystem.close_popup()
				showing_popup = false

func _ready():
	time_hour = starting_hour
	time_coroutine = time_moving()

func _process(delta):
	$GUI/Tooltip.rect_position = get_viewport().get_mouse_position()

func move_player(target_position):
	stop_working_anim()
	var path = $Navigation2D.get_simple_path($Player.position, target_position)
	$Player.take_path(path)
	$Line2D.points = path

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
		time_hour += 1
		if time_hour > 23:
			day_count += 1
			time_hour = 0
		emit_signal("hour_pass", time_hour)

func get_object_hover(object_name, object_level, object_cost):
	object_hover = object_name
	object_level_hover = object_level
	object_cost_hover = object_cost

func get_activity(p_activity_name, p_activity_type, p_activity_gain, 
	p_activity_scale, p_activity_from):
	activity_name = p_activity_name
	activity_type = p_activity_type
	activity_gain = p_activity_gain
	activity_scale = p_activity_scale
	activity_from = p_activity_from
	object_level_active = object_level_fix
	move_player(object_position)

func _on_Player_path_done():
	if activity_name != "null":
		is_working = true
		play_working_anim()
		event_chance_pool = $EventSystem.get_chance(activity_name)

func play_working_anim():
	if activity_from == "Stove":
		$Player/AnimatedSprite.play("eating")
	else:
		$Player.visible = false
		if activity_from == "Bed":
			$Objects/Bed.play("sleeping")
		elif activity_from == "PC":
			$Objects/PC.play("working")
		elif activity_from == "TV":
			$TileMap/Sofa.play("activity")
			$Objects/Console.play("activities")

func stop_working_anim():
	$Player.visible = true
	$Objects/Bed.play("default")
	$Objects/PC.play("default")
	$TileMap/Sofa.play("default")
	$Objects/Console.play("default")

func _on_World_hour_pass(time):
	if is_working:
		health_gain_total = 0
		happiness_gain_total = 0
		work_gain_total = 0
		if activity_type == "Health":
			health_gain_total += activity_gain + activity_scale * object_level_active
			$GUI/HealthBar.is_decreasing = false
		elif activity_type == "Happiness":
			happiness_gain_total += activity_gain + activity_scale * object_level_active
			$GUI/HappinessBar.is_decreasing = false
		elif activity_type == "Work":
			work_gain_total += activity_gain + activity_scale * object_level_active
		if event_chance_pool != null:
			grab_event(event_chance_pool)
		$GUI/HealthBar.value += health_gain_total
		$GUI/HappinessBar.value += happiness_gain_total
		money += work_gain_total
		$GUI/HealthBar/Status.get_gain_number(health_gain_total)
		$GUI/HappinessBar/Status.get_gain_number(happiness_gain_total)
		$GUI/MoneyText/Status.get_gain_number(work_gain_total)
		reset_money()

func reset_money():
	$GUI/MoneyText.text = str(money) + " $"

func reset_element_decrease():
	$GUI/HealthBar.is_decreasing = true
	$GUI/HappinessBar.is_decreasing = true

func grab_event(pool : PoolIntArray):
	randomize()
	var number = randi() % 100
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
	if gain_value[0] < 0:
		var new_value = gain_value[0] + activity_scale * object_level_active
		if new_value > -2:
			new_value = -2
		health_gain_total += new_value
	elif gain_value[0] != 0:
		health_gain_total += gain_value[0] + activity_scale * object_level_active
	if gain_value[1] < 0:
		var new_value = gain_value[1] + activity_scale * object_level_active
		if new_value > -2:
			new_value = -2
		happiness_gain_total += new_value
	elif gain_value[1] != 0:
		happiness_gain_total += gain_value[1] + activity_scale * object_level_active
	if gain_value[2] < 0:
		var new_value = gain_value[2] + activity_scale * object_level_active
		if new_value > -2:
			new_value = -2
		work_gain_total += new_value
	elif gain_value[2] != 0:
		work_gain_total += gain_value[2] + activity_scale * object_level_active
	$GUI/EventPanel/Label.text = gain_desc
	$GUI/EventPanel.visible = true
	
func chance_event(index : int):
	var new_pool = $EventSystem.get_chance($EventSystem.get_event_name(index))
	if new_pool[0] == -2:
		randomize()
		var number = randi() % 100
		if number <= $GUI/HappinessBar.value:
			gain_event(new_pool[1])
		else:
			gain_event(new_pool[1] + 1)
	else:
		grab_event(new_pool)

func decision_event(index : int):
	var new_pool = $EventSystem.get_chance($EventSystem.get_event_name(index))
	decision_index = [new_pool[0], new_pool[50]]
	var question = $EventSystem.get_event_desc(index)
	var option1 = $EventSystem.get_event_desc(new_pool[0])
	var option2 = $EventSystem.get_event_desc(new_pool[50])
	$GUI/DecisionPanel.visible = true
	$GUI/DecisionPanel/Text.text = question
	$GUI/DecisionPanel/Option1/Label.text = option1
	$GUI/DecisionPanel/Option2/Label.text = option2
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


func _on_Panel_mouse_entered():
	inside_popup = true


func _on_Panel_mouse_exited():
	inside_popup = false


func _on_Button_mouse_entered():
	inside_popup = true


func _on_Button2_mouse_entered():
	inside_popup = true


func _on_Button3_mouse_entered():
	inside_popup = true

extends Node2D


export (float) var seconds_per_hour = 10.0
export (int) var starting_hour
export (int) var buff_debuff_time
export (int) var happiness_buff_chance
export (int) var happiness_debuff_chance
export (int) var health_buff_chance
export (int) var health_debuff_chance
export (float) var money_buff_amplifier
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
var pause_hover : bool = false
var happiness_buff_time : int = 0
var health_buff_time : int = 0
var happiness_buff : bool = false
var health_buff : bool = false
var happiness_debuff : bool = false
var health_debuff : bool = false
var tutorial1 : bool = false
var tutorial22 : bool = false
var tutorial2 : bool = false
var tutorial3 : bool = false
var tutorial4 : bool = false
var tutorial42 : bool = false
var tutorial5 : bool = false
var tutorial52 : bool = false

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and event.pressed and not is_pause:
			if tutorial_check():
				if object_hover != "null" and not showing_popup:
					object_fix = object_hover
					object_level_fix = object_level_hover
					object_cost_fix = object_cost_hover
					object_position = event.position
					showing_popup = true
					$GUI/ActivitySystem.show_popup(object_fix, object_level_fix, 
						object_cost_fix, object_position)
				elif not showing_popup and not pause_hover:
					object_fix = "null"
					object_level_hover = 0
					object_cost_fix = 0
					activity_name = "null"
					activity_type = "null"
					activity_from = "null"
					activity_gain = 0
					activity_scale = 0
					event_chance_pool = []
					decision_index = []
					move_player(event.position)
				elif not inside_popup and not pause_hover:
					close_popup()

func _ready():
	time_hour = starting_hour
	#time_coroutine = time_moving()
	$Objects/Windows.change_window(starting_hour)
	if Global.tutorial:
		tutorial1 = true
		$Tutorial/Tutorial1.visible = true
	else:
		time_coroutine = time_moving()

func close_popup():
	object_fix = "null"
	object_level_hover = 0
	object_cost_fix = 0
	$GUI/ActivitySystem.close_popup()
	showing_popup = false

func move_player(target_position):
	is_working = false
	reset_element_decrease()
	stop_working_anim()
	$Audio.stop_all_activity_sound()
	var path = $Navigation2D.get_simple_path($Player.position, target_position)
	$Player.take_path(path)
	$Line2D.points = path

func pause_game():
	is_pause = true

func unpause_game():
	is_pause = false
	emit_signal("unpause")
	if $GUI/Pause.disabled == true:
		$GUI/Pause.disabled = false

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
	p_activity_scale, p_activity_from, p_object_level):
	activity_name = p_activity_name
	activity_type = p_activity_type
	activity_gain = p_activity_gain
	activity_scale = p_activity_scale
	activity_from = p_activity_from
	object_level_active = p_object_level
	move_player(object_position)

func _on_Player_path_done():
	if activity_name != "null":
		is_working = true
		play_working_anim()
		$Audio.play_activity_sound(activity_from)
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
	health_gain_total = 0
	happiness_gain_total = 0
	work_gain_total = 0
	if is_working:
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
		if is_pause:
			yield(self, "unpause")
		if happiness_buff:
			work_gain_total = int(work_gain_total * money_buff_amplifier)
		money += work_gain_total
	if $GUI/HappinessBar.is_decreasing:
		happiness_gain_total += $GUI/HappinessBar.decrease_rate
	if $GUI/HealthBar.is_decreasing:
		health_gain_total += $GUI/HealthBar.decrease_rate
	$GUI/HealthBar.value += health_gain_total
	$GUI/HappinessBar.value += happiness_gain_total
	$GUI/HealthBar/Status.get_gain_number(health_gain_total)
	$GUI/HappinessBar/Status.get_gain_number(happiness_gain_total)
	$GUI/MoneyText/Status.get_gain_number(work_gain_total)
	if tutorial2:
		tutorial22 = true
		tutorial2 = false
		$Tutorial/Tutorial2.visible = true
	reset_money()
	buff_check()
	if $GUI/HealthBar.value <= 0:
		$GUI/Pause.disabled = true
		pause_game()
		$GUI/GameOverPanel.game_over(1, day_count, money)
		$Audio.play_game_over_sound()
	if $GUI/HappinessBar.value <= 0:
		$GUI/Pause.disabled = true
		pause_game()
		$GUI/GameOverPanel.game_over(2, day_count, money)
		$Audio.play_game_over_sound()

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
	if tutorial4:
		$Tutorial/Tutorial4.visible = true
		tutorial42 = true
		tutorial4 = false
	
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
	$GUI/Pause.disabled = true
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

func buff_check():
	if happiness_buff:
		happiness_buff_time -= 1
		if happiness_buff_time <= 0 or $GUI/HappinessBar.value <= 50:
			happiness_buff_time = 0
			happiness_buff = false
			$GUI/HappinessBuff.visible = false
	elif happiness_debuff:
		happiness_buff_time -= 1
		if happiness_buff_time <= 0 or $GUI/HappinessBar.value >= 50:
			happiness_buff_time = 0
			happiness_debuff = false
			$GUI/HappinessDebuff.visible = false
			$Player.current_speed -= $Player.debuff_speed
	if health_buff:
		health_buff_time -= 1
		if health_buff_time <= 0 or $GUI/HealthBar.value <= 50:
			health_buff_time = 0
			health_buff = false
			$GUI/HealthBuff.visible = false
			$Player.current_speed -= $Player.buff_speed
	elif health_debuff:
		health_buff_time -= 1
		if health_buff_time <= 0 or $GUI/HealthBar.value >= 50:
			health_buff_time = 0
			health_debuff = false
			$GUI/HealthDebuff.visible = false
			$GUI/Debuff.visible = false
	if $GUI/HappinessBar.value == 100:
		randomize()
		var number = randi() % 100
		if number <= happiness_buff_chance:
			happiness_buff_time = buff_debuff_time
			if not happiness_buff:
				happiness_buff = true
				$GUI/HappinessBuff.visible = true
				if tutorial5:
					$Tutorial/Tutorial5.visible = true
					tutorial52 = true
					tutorial5 = false
	elif $GUI/HappinessBar.value <= 10:
		randomize()
		var number = randi() % 100
		if number <= happiness_debuff_chance:
			happiness_buff_time = buff_debuff_time
			if not happiness_debuff:
				happiness_debuff = true
				$GUI/HappinessDebuff.visible = true
				$Player.current_speed += $Player.debuff_speed
				if tutorial5:
					$Tutorial/Tutorial5.visible = true
					tutorial52 = true
					tutorial5 = false
	if $GUI/HealthBar.value == 100:
		randomize()
		var number = randi() % 100
		if number <= health_buff_chance:
			health_buff_time = buff_debuff_time
			if not health_buff:
				health_buff = true
				$GUI/HealthBuff.visible = true
				$Player.current_speed += $Player.buff_speed
				if tutorial5:
					$Tutorial/Tutorial5.visible = true
					tutorial52 = true
					tutorial5 = false
	elif $GUI/HealthBar.value <= 10:
		randomize()
		var number = randi() % 100
		if number <= health_debuff_chance:
			health_buff_time = buff_debuff_time
			if not health_debuff:
				health_debuff = true
				$GUI/HealthDebuff.visible = true
				$GUI/Debuff.visible = true
				if tutorial5:
					$Tutorial/Tutorial5.visible = true
					tutorial52 = true
					tutorial5 = false

func tutorial_check():
	if not Global.tutorial:
		return true
	else:
		if tutorial1:
			if object_hover == "null" and not pause_hover:
				$Tutorial/Tutorial1.visible = false
				tutorial1 = false
				tutorial2 = true
				time_coroutine = time_moving()
				return true
			else:
				return false
		if tutorial22:
			$Tutorial/Tutorial2.visible = false
			$Tutorial/Tutorial3.visible = true
			tutorial22 = false
			tutorial3 = true
			return false
		if tutorial3:
			if object_hover != "null" and not showing_popup:
				$Tutorial/Tutorial3.visible = false
				tutorial3 = false
				tutorial4 = true
				tutorial5 = true
				return true
			else:
				return false
		if tutorial42:
			$Tutorial/Tutorial4.visible = false
			tutorial42 = false
			return false
		if tutorial52:
			$Tutorial/Tutorial5.visible = false
			tutorial52 = false
			return false
		return true


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


func _on_Pause_pressed():
	if is_pause:
		$GUI/PausePanel.visible = false
		$Audio.play_activity_sound(activity_from)
		unpause_game()
	else:
		$GUI/PausePanel.visible = true
		$Audio.stop_all_activity_sound()
		pause_game()


func _on_Pause_mouse_entered():
	pause_hover = true


func _on_Pause_mouse_exited():
	pause_hover = false


func _on_ExitPopUp_pressed():
	close_popup()


func _on_Quit_pressed():
	get_tree().change_scene("res://scenes/menu.tscn")


func _on_Continue_pressed():
	$GUI/PausePanel.visible = false
	$Audio.play_activity_sound(activity_from)
	unpause_game()

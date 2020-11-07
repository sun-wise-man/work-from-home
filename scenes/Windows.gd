extends Node2D


#func _ready():
	#change_window(get_parent().get_parent().starting_hour)

func _on_World_hour_pass(time):
	change_window(time)
			
func change_window(time):
	if time <= 3:
		$WindowAnim.frame = 0
		$WindowAnim2.frame = 0
	elif time <= 6:
		$WindowAnim.frame = 1
		$WindowAnim2.frame = 1
	elif time <= 8:
		$WindowAnim.frame = 2
		$WindowAnim2.frame = 2
	elif time <= 10:
		$WindowAnim.frame = 3
		$WindowAnim2.frame = 3
	elif time <= 12:
		$WindowAnim.frame = 4
		$WindowAnim2.frame = 4
	elif time <= 15:
		$WindowAnim.frame = 5
		$WindowAnim2.frame = 5
	elif time <= 18:
		$WindowAnim.frame = 6
		$WindowAnim2.frame = 6
	elif time <= 20:
		$WindowAnim.frame = 7
		$WindowAnim2.frame = 7
	elif time <= 22:
		$WindowAnim.frame = 8
		$WindowAnim2.frame = 8
	elif time <= 24:
		$WindowAnim.frame = 9
		$WindowAnim2.frame = 9

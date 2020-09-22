extends Node2D

var time_count : int = 0

func _on_World_hour_pass(time):
	time_count += 10
	if time_count - 24 >= 0:
		time_count -= 24
		if $WindowAnim.frame == 9:
			$WindowAnim.frame = 0
			$WindowAnim2.frame = 0
		else:
			$WindowAnim.frame += 1
			$WindowAnim2.frame += 1

extends Node2D

func play_activity_sound(object_name):
	if object_name == "Bed":
		$Sleep.play()
	elif object_name == "Bathroom":
		$Shower.play()
	elif object_name == "PC":
		$Pc.play()
	elif object_name == "TV":
		$Tv.play()
	elif object_name == "Stove":
		$Eat.play()

func stop_all_activity_sound():
	$Sleep.stop()
	$Shower.stop()
	$Pc.stop()
	$Tv.stop()
	$Eat.stop()

func play_game_over_sound():
	stop_all_activity_sound()
	$GameOver.play()

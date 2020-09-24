extends KinematicBody2D

export (int) var speed = 50

var idle = true
signal path_done

# Untuk menyimpan runtutan perjalanan
var path : = PoolVector2Array()

func _ready():
	$AnimatedSprite.play("idle")

func _process(delta):
	# Calculate the movement distance for this frame
	var distance_to_walk = speed * delta
	
	# Move the player along the path until he has run out of movement or the path ends.
	while distance_to_walk > 0 and path.size() > 0:
		var distance_to_next_point = position.distance_to(path[0])
		if distance_to_walk <= distance_to_next_point:
			# The player does not have enough movement left to get to the next point.
			position += position.direction_to(path[0]) * distance_to_walk
		else:
			# The player get to the next point
			position = path[0]
			path.remove(0)
			if path.size() == 0:
				$AnimatedSprite.play("idle")
				emit_signal("path_done")
			flip_char()
		# Update the distance to walk
		distance_to_walk -= distance_to_next_point

func flip_char():
	if path.size() > 0:
		var direction = sign(path[0].x - $AnimatedSprite.global_position.x)
		if direction < 0:
			$AnimatedSprite.set_flip_h(true)
		else:
			$AnimatedSprite.set_flip_h(false)
			
func take_path(the_path):
	path = the_path
	flip_char()
	$AnimatedSprite.play("walk")

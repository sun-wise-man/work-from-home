extends KinematicBody2D

export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()
var idle = true

func _input(event):
	var direction = sign(get_global_mouse_position().x - $AnimatedSprite.global_position.x)
	if event.is_action_pressed('click'):
		target = get_global_mouse_position()
		if direction < 0:
			$AnimatedSprite.set_flip_h(true)
		else:
			$AnimatedSprite.set_flip_h(false)

func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	

	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
		$AnimatedSprite.play("walk")

	else:
		$AnimatedSprite.play("idle")
	

extends CharacterBody2D

const JUMP_VELOCITY = -320.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
		if Input.is_action_pressed("roll_key"):
			velocity += get_gravity() * delta

	if is_on_floor():
		if not get_parent().game_running :
			$AnimatedSprite2D.play("idle")
		else:
			$runCol.disabled = false
			if Input.is_action_pressed("jump_key"):
				velocity.y = JUMP_VELOCITY
				$Jump_sound.play()
			elif Input.is_action_pressed("roll_key"):
				$AnimatedSprite2D.play("roll")
				$runCol.disabled = true
			else:
				$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")

	move_and_slide()

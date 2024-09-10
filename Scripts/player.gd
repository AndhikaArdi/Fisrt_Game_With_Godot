extends CharacterBody2D

const JUMP_VELOCITY = -320.0

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	if is_on_floor():
		$runCol.disabled = false
		if Input.is_action_pressed("ui_accept"):
			velocity.y = JUMP_VELOCITY
		elif Input.is_action_pressed("ui_down"):
			$AnimatedSprite2D.play("roll")
			$runCol.disabled = true
		else:
			$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("jump")

	move_and_slide()

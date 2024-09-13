extends Area2D

var prior_frame:int = 0

func _process(delta: float) -> void:
	#moving the skeleton
	position.x -= get_parent().speed / 4
	
	#Animation and collision
	var sprite:AnimatedSprite2D = $AnimatedSprite2D

	# make sure the collision for the current frame is not disabled
	var curr_collision := get_node(str("Coll", sprite.frame)) as CollisionShape2D
	curr_collision.disabled = false

	# if the frame is the same we last seen, we are done
	if prior_frame == sprite.frame:
		return
	
	# the frame is different, thus disable the collision for the prior frame
	var old_collision := get_node(str("Coll", prior_frame)) as CollisionShape2D
	old_collision.disabled = true

	# keep track of the frame we have seen
	prior_frame = sprite.frame

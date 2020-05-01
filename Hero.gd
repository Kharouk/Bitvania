extends KinematicBody2D
# Kinematic bodies are user-controlled bodies that don't really know physics unless we assign it some
# other bodies typically look at it as if it was a static body (check docs)

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25

# x,y coordinate of 0 -> we are not moving when we start
var motion = Vector2.ZERO

# similar to _processs but for physics based movement
func _physics_process(delta):
	var input_vector = Vector2.ZERO
	# if user presses left, it's -1 and right is 0, if pressing right, it is 1 and left is 0.
	# value is between -1 to 1
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	input_vector.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if input_vector != Vector2.ZERO:
		# we want the user to move
		motion += input_vector * ACCELERATION * delta
		# sets a limit so our hero doesn't move too fast
		motion = motion.clamped(MAX_SPEED)
	else:
		# reduce the motion to 0 by FRICTION (25%)
		motion = motion.linear_interpolate(Vector2.ZERO, FRICTION)
	
	# detects collision with other bodies
	# allows you to keep moving against the other body as you "slide"
	motion = move_and_slide(motion)

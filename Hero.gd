extends KinematicBody2D
# Kinematic bodies are user-controlled bodies that don't really know physics unless we assign it some
# other bodies typically look at it as if it was a static body (check docs)

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25

export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
# makes slopes of a 45 degree "work"
export (int) var MAX_SLOPE_ANGLE = 46

# x,y coordinate of 0 -> we are not moving when we start
var motion = Vector2.ZERO

# similar to _processs but for physics based movement
func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_force(delta, input_vector)
	apply_friction(input_vector)
	move_hero()

func get_input_vector():
	var input_vector = Vector2.ZERO
	# if user presses left, it's -1 and right is 0, if pressing right, it is 1 and left is 0; value is between -64 to 64
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector

func apply_horizontal_force(delta, input_vector):
	if input_vector.x != 0:
		# we need to apply delta to any value that changes over time
		motion.x += input_vector.x * ACCELERATION * delta
		# sets a speed limit so our hero doesn't move too fast
		motion = motion.clamped(MAX_SPEED)

func apply_friction(input_vector):
	if input_vector.x == 0:
		# lerp calls the vector type's linear_interpolate method
		motion.x = lerp(motion.x, 0, FRICTION)

func move_hero():
	# detects collision with other bodies; allows you to keep moving against the other body as you "slide"
	# move and slide already takes into account delta time
	motion = move_and_slide(motion)

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

# similar to _process but for physics based movement
func _physics_process(delta):
	var input_vector = get_input_vector()
	apply_horizontal_force(delta, input_vector)
	apply_friction(input_vector)
	jump_check()
	apply_gravity(delta)
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
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func apply_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():
		# lerp calls the vector type's linear_interpolate method
		motion.x = lerp(motion.x, 0, FRICTION)

func jump_check():
	if is_on_floor():
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
	else:
		# allows us to cancel the jump fully and jump shorter (not entirely clear on the second conditional but if we remove it then the player can jump as much as they want.. which sounds cool for a power up)
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
			
func apply_gravity(delta):
	motion.y += GRAVITY * delta
	# prevents us from falling faster than our jump force:
	motion.y = min(motion.y, JUMP_FORCE)

func move_hero():
	# detects collision with other bodies; allows you to keep moving against the other body as you "slide"
	# move and slide already takes into account delta time
	# we tell move_and_slide that the floor is facing up
	motion = move_and_slide(motion, Vector2.UP)


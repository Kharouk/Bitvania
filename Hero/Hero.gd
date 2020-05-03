extends KinematicBody2D
# Kinematic bodies are user-controlled bodies that don't really know physics unless we assign it some
# other bodies typically look at it as if it was a static body (check docs)

const DustEffect: PackedScene = preload("res://Effects/DustEffect.tscn")

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25

export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128
# makes slopes of a 45 degree "work"
export (int) var MAX_SLOPE_ANGLE = 46

# x,y coordinate of 0 -> we are not moving when we start
var motion = Vector2.ZERO

var snap_vector := Vector2.DOWN
var has_just_jumped : bool = false

onready var sprite = $Sprite
onready var spriteAnimator = $SpriteAnimator
# allows us to jump after we leave the platform:
onready var coyoteJumpTimer = $CoyoteJumpTimer

# similar to _process but for physics based movement
func _physics_process(delta):
	has_just_jumped = false
	var input_vector = get_input_vector()
	apply_horizontal_force(delta, input_vector)
	apply_friction(input_vector)
	update_snap_vector()
	jump_check()
	apply_gravity(delta)
	update_animations(input_vector)
	move_hero()
	
func create_dust_effect():
	var dust_position = global_position # the origin is at the hero's feet
	dust_position.x += rand_range(-4, 4)
	var dustEffect = DustEffect.instance()
	print(get_tree().current_scene.name)
	get_tree().current_scene.add_child(dustEffect)
	dustEffect.global_position = dust_position

func get_input_vector() -> Vector2:
	var input_vector = Vector2.ZERO
	# if user presses left, it's -1 and right is 0, if pressing right, it is 1 and left is 0; value is between -64 to 64
	input_vector.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	return input_vector

func apply_horizontal_force(delta: float, input_vector: Vector2) -> void:
	if input_vector.x != 0:
		# we need to apply delta to any value that changes over time
		motion.x += input_vector.x * ACCELERATION * delta
		# sets a speed limit so our hero doesn't move too fast
		motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)

func apply_friction(input_vector):
	if input_vector.x == 0 and is_on_floor():
		# lerp calls the vector type's linear_interpolate method
		motion.x = lerp(motion.x, 0, FRICTION)

func update_snap_vector():
	if is_on_floor():
		snap_vector = Vector2.DOWN
		
func jump_check():
	if is_on_floor() or coyoteJumpTimer.time_left > 0:
		if Input.is_action_just_pressed("ui_up"):
			motion.y = -JUMP_FORCE
			has_just_jumped = true
			snap_vector = Vector2.ZERO
	else:
		# allows us to cancel the jump fully and jump shorter (not entirely clear on the second conditional but if we remove it then the player can jump as much as they want.. which sounds cool for a power up)
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
			
func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		# prevents us from falling faster than our jump force:
		motion.y = min(motion.y, JUMP_FORCE)

func update_animations(input_vector):
	if input_vector.x != 0:
		# sign returns -1, 0 or 1 depending if it's negative, zero, or positive
		# have to use it since controllers might give a different number
		sprite.scale.x = sign(input_vector.x)
		spriteAnimator.play("Run")
	else:
		spriteAnimator.play("Idle")
	
	if not is_on_floor():
		spriteAnimator.play("Jump")
		

func move_hero():
	var was_in_air = not is_on_floor()
	var was_on_floor = is_on_floor()
	var last_position = position
	var last_motion = motion
	var snap_force = 4
	
	# detects collision with other bodies; allows you to keep moving against the other body as you "slide"
	# move and slide already takes into account delta time
	# we tell move_and_slide_with_snap the motion, our snap vector towards the floor, where is the floor (pointing up), that we want to snap to slope, 4 max slides, and the 45 degree to radian
	motion = move_and_slide_with_snap(motion, snap_vector * snap_force, Vector2.UP, true, 4, deg2rad(MAX_SLOPE_ANGLE))
	
	# Landing
	if was_in_air and is_on_floor():
		# If we are landing on a slope, we keep our previous momentum; no awkward stopping
		motion.x = last_motion.x
		create_dust_effect()

	# Just left ground:
	if was_on_floor and !is_on_floor() and not has_just_jumped:
		# prevents it from hopping the player when going up a slope 
		motion.y = 0
		position.y = last_position.y
		coyoteJumpTimer.start()
	
	# Prevent sliding (hack)
	if is_on_floor() and get_floor_velocity().length() == 0 and abs(motion.x) < 1:
		# if we are on a slope, that is not moving, and we are sliding just a little bit, then set our position to the position we are at when we first touch the slope
		position.x = last_position.x
	

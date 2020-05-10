extends KinematicBody2D
# Kinematic bodies are user-controlled bodies that don't really know physics unless we assign it some
# other bodies typically look at it as if it was a static body (check docs)

const JumpEffect = preload("res://Effects/JumpEffect.tscn")
const PlayerBullet = preload("res://Hero/Gun/PlayerBullet.tscn")
const DustEffect = preload("res://Effects/DustEffect.tscn")
const WallDustEffect = preload("res://Effects/WallDustEffect.tscn")

var PlayerStats = ResourceLoader.PlayerStats
var MainInstances = ResourceLoader.MainInstances

export (int) var ACCELERATION = 512
export (int) var MAX_SPEED = 64
export (float) var FRICTION = 0.25

# Applying Jump Skill
export (int) var GRAVITY = 200
export (int) var JUMP_FORCE = 128

# Allow Wall slides
export (int) var WALL_SLIDE_SPEED = 48
export (int) var MAX_WALL_SLIDE_SPEED = 128

# makes slopes of a 45 degree "work"
export (int) var MAX_SLOPE_ANGLE = 46
export (int) var BULLET_SPEED = 250

enum {
	MOVE,
	WALL_SLIDE
}

# State can be MOVE or WALL_SLIDE.
var state = MOVE
# x,y coordinate of 0 -> we are not moving when we start
var motion = Vector2.ZERO
var invincible = false setget set_invincible
var snap_vector := Vector2.DOWN
var has_just_jumped : bool = false
var double_jump := true

onready var sprite = $Sprite
onready var spriteAnimator = $SpriteAnimator
onready var blinkAnimator = $BlinkAnimator
# allows us to jump after we leave the platform:
onready var coyoteJumpTimer = $CoyoteJumpTimer
# setting up our gun's "fire rate"
onready var fireBulletTimer = $FireBulletTimer
onready var muzzle = $Sprite/PlayerGun/Sprite/Muzzle
onready var gun = $Sprite/PlayerGun

func set_invincible(value):
	invincible = value

func _ready():
	PlayerStats.connect("player_died", self, "_on_died")
	MainInstances.Player = self

func _exit_tree():
	MainInstances.Player = null

# similar to _process but for physics based movement
func _physics_process(delta):
	has_just_jumped = false

	match state:
		MOVE:
			var input_vector = get_input_vector()
			apply_horizontal_force(delta, input_vector)
			apply_friction(input_vector)
			update_snap_vector()
			jump_check()
			apply_gravity(delta)
			update_animations(input_vector)
			set_motion()
			wall_slide_check()
		WALL_SLIDE:
			spriteAnimator.play("Wall Slide")
			var wall_axis = get_wall_axis()
			if wall_axis != 0:
				# Setting the direction of the sprite
				sprite.scale.x = wall_axis

			wall_slide_jump_check(wall_axis)
			wall_slide_drop(delta)
			set_motion()
			wall_detach(delta, wall_axis)


	
	if Input.is_action_pressed("fire") and fireBulletTimer.time_left == 0:
		fire_bullet()

func fire_bullet():
	var bullet = Utils.instance_scene_on_main(PlayerBullet, muzzle.global_position)
	# setting the velocity based on a right arrow, rotated based on our gun/mouse movement, multiplied by the speed:
	bullet.velocity = Vector2.RIGHT.rotated(gun.rotation) * BULLET_SPEED
	# setting the direction of the velocity based on our hero's scale of (-1 -> 1)
	bullet.velocity.x *= sprite.scale.x
	# sets the rotation based on the angle representation of the bullet velocity. 
	bullet.rotation = bullet.velocity.angle()
	fireBulletTimer.start()
	
func create_dust_effect():
	var dust_position = global_position # the origin is at the hero's feet
	dust_position.x += rand_range(-4, 4)
	Utils.instance_scene_on_main(DustEffect, dust_position)

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
			jump(JUMP_FORCE)
			has_just_jumped = true
	else:
		# allows us to cancel the jump fully and jump shorter (not entirely clear on the second conditional but if we remove it then the player can jump as much as they want.. which sounds cool for a power up)
		if Input.is_action_just_released("ui_up") and motion.y < -JUMP_FORCE/2:
			motion.y = -JUMP_FORCE/2
		
		if Input.is_action_just_pressed("ui_up") and double_jump:
			jump(JUMP_FORCE * .75)
			double_jump = false

func jump(force):
	Utils.instance_scene_on_main(JumpEffect, global_position)
	motion.y = -force
	snap_vector = Vector2.ZERO

			
func apply_gravity(delta):
	if not is_on_floor():
		motion.y += GRAVITY * delta
		# prevents us from falling faster than our jump force:
		motion.y = min(motion.y, JUMP_FORCE)

func update_animations(input_vector):
	# sign returns -1, 0 or 1 depending if it's negative, zero, or positive
	# have to use it since controllers might give a different number
	sprite.scale.x = sign(get_local_mouse_position().x)
	if input_vector.x != 0:
		spriteAnimator.play("Run")
		spriteAnimator.playback_speed = input_vector.x * sprite.scale.x
	else:
		spriteAnimator.playback_speed = 1
		spriteAnimator.play("Idle")
	
	if not is_on_floor():
		spriteAnimator.play("Jump")
		

func set_motion():
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
		Utils.instance_scene_on_main(JumpEffect, global_position)
		double_jump = true

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
	
func _on_died():
	queue_free()

func wall_slide_check():
	if not is_on_floor() and is_on_wall():
		state = WALL_SLIDE
		# you get the double jump skill back on the wall
		double_jump = true
		create_dust_effect()

func get_wall_axis():
	var is_right_wall = test_move(transform, Vector2.RIGHT)
	var is_left_wall = test_move(transform, Vector2.LEFT)
	var wall_direction_int = int(is_left_wall) - int(is_right_wall)
	return wall_direction_int

func wall_slide_jump_check(wall_axis):
	if Input.is_action_just_pressed("ui_up"):
		motion.x = wall_axis * MAX_SPEED
		motion.y = -JUMP_FORCE/1.25
		state = MOVE
		var dust_position = global_position + Vector2(wall_axis*4, -2)
		var dust = Utils.instance_scene_on_main(WallDustEffect, dust_position)
		dust.scale.x = wall_axis

func wall_slide_drop(delta):
	var slide_speed = WALL_SLIDE_SPEED
	if Input.is_action_pressed("ui_down"):
		slide_speed = MAX_WALL_SLIDE_SPEED

	motion.y = min(motion.y + GRAVITY * delta, slide_speed)

func wall_detach(delta, wall_axis):
	if Input.is_action_just_pressed("ui_right"):
		motion.x = ACCELERATION * delta
		state = MOVE
	if Input.is_action_just_pressed("ui_left"):
		motion.x = -ACCELERATION * delta
		state = MOVE

	if wall_axis == 0 or is_on_floor():
		state = MOVE

func _on_Hurtbox_hit(damage):
	if not invincible:
		PlayerStats.health -= damage
		blinkAnimator.play("Blink")

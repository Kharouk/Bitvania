extends "res://Enemies/Enemy.gd"

enum DIRECTION { LEFT = -1, RIGHT = 1 }

export(DIRECTION) var WALKING_DIRECTION

var state

onready var sprite = $Sprite

# Raycasting:
onready var floorLeft = $FloorLeft
onready var floorRight = $FloorRight
onready var wallLeft = $WallLeft
onready var wallRight = $WallRight

func _ready():
	state = WALKING_DIRECTION
	motion.y = 8
	
func _physics_process(_delta):
	# like a switch statement:
	match state:
		DIRECTION.RIGHT:
			motion.x = MAX_SPEED
			if not floorRight.is_colliding() || wallRight.is_colliding():
				# if there is no floor to the right or against a wall, turn around:
				state = DIRECTION.LEFT
		
		DIRECTION.LEFT:
			motion.x = -MAX_SPEED
			if not floorLeft.is_colliding() || wallLeft.is_colliding():
				# if there is no floor to the right or against a wall, turn around:
				state = DIRECTION.RIGHT
	
	# get our motion.x 'signed' so that it's 1 or -1 for direction 
	sprite.scale.x = sign(motion.x)
	
	# passing in our motion, setting the 'intensity of the snap', which direction the floor is pointing towards, apply to slope, 4?, and the radian of 46 for slopes
	motion = move_and_slide_with_snap(motion, Vector2.DOWN * 4, Vector2.UP, true, 4, deg2rad(46))

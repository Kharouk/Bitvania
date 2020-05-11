extends "res://Enemies/Enemy.gd"

enum DIRECTION {
  LEFT = -1, 
  RIGHT = 1
}

export(DIRECTION) var WALKING_DIRECTION = DIRECTION.RIGHT

onready var floorCast: RayCast2D = $FloorCast
onready var wallCast: RayCast2D = $WallCast

func _ready():
  wallCast.cast_to.x *= WALKING_DIRECTION

func _physics_process(delta):
  if wallCast.is_colliding():
	  # crawling up the wall:
	  global_position = wallCast.get_collision_point()
	  rotate_on_collision(wallCast)
  else:
	  # slightly rotates the floor cast
	  floorCast.rotation_degrees = -MAX_SPEED * 10 * WALKING_DIRECTION * delta
	
  if floorCast.is_colliding():
	  # helps us move a little bit at a time, works with slopes:
	  global_position = floorCast.get_collision_point()
	  rotate_on_collision(floorCast)
  else: 
	  rotation_degrees += 20 * WALKING_DIRECTION

func rotate_on_collision(raycast):
  var normal = raycast.get_collision_normal()
  rotation = normal.rotated(deg2rad(90)).angle()

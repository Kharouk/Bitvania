extends "res://Enemies/Enemy.gd"
# Welcome, to the biggest, baddest enemy you've ever seen.

var MainInstances = ResourceLoader.MainInstances
const Bullet = preload("res://Enemies/Projectiles/EnemyBullet.tscn")

export(int) var ACCELERATION = 70

onready var rightWallCheck = $RightWallCheck
onready var leftWallCheck = $LeftWallCheck

signal died

func _ready():
  pass

func _process(delta):
  chase_player(delta)

func chase_player(delta):
  var player = MainInstances.Player
  if player != null:
    var direction_to_move = sign(player.global_position.x - global_position.x)
    motion.x += ACCELERATION * delta * direction_to_move
    motion.x = clamp(motion.x, -MAX_SPEED, MAX_SPEED)
    global_position += motion.x * delta

func _on_Shooting_timeout():
	pass # Replace with function body.

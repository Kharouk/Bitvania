extends "res://Enemies/Enemy.gd"

const EnemyBullet = preload("res://Enemies/Projectiles/EnemyBullet.tscn")

export(int) var BULLET_SPEED = 30
export(float) var SPREAD = 15

onready var fireDirection = $FireDirection
onready var bulletSpawnPoint = $BulletSpawnPoint

func fire_bullet():
  var bullet = Utils.instance_scene_on_main(EnemyBullet, bulletSpawnPoint.global_position)
  var velocity = (fireDirection.global_position - global_position).normalized() * BULLET_SPEED
  velocity = velocity.rotated(deg2rad(rand_range(-SPREAD, SPREAD)))

  bullet.velocity = velocity

extends "res://Hero/Projectile.gd"

const EnemyDeathEffect = preload("res://Effects/EnemyDeathEffect.tscn")

const BRICK_LAYER_BIT = 4

func _on_Hitbox_body_entered(body):
  if body.get_collision_layer_bit(BRICK_LAYER_BIT):
	body.queue_free()
	var brick_center = Vector2(8,8)
	Utils.instance_scene_on_main(EnemyDeathEffect, body.global_position + brick_center)
	
  ._on_Hitbox_body_entered(body)

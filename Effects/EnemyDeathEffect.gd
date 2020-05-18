extends Node2D

func _ready():
	SoundFX.play("EnemyDie", 1, -10)

func _on_FinalDustEffect_tree_exited():
	queue_free()

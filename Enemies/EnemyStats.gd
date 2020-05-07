extends Node

signal enemy_died

export(int) var max_health = 1

# needs to be onready since we are using that export variable above since we could change the variable in the gui
onready var health = max_health setget set_health

func set_health(value):
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("enemy_died")

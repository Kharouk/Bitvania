extends Resource
class_name PlayerStats

var max_health = 4
export(float) var shake_amount = 0.25

var health = max_health setget set_health

signal player_died

func set_health(value):
	if value < health:
		Events.emit_signal("add_screen_shake", shake_amount, 0.5)
		
	health = clamp(value, 0, max_health)
	if health == 0:
		emit_signal("player_died")

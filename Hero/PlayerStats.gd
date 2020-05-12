extends Resource
class_name PlayerStats

export(float) var shake_amount = 0.25

var max_health = 4
var health = max_health setget set_health

var max_missiles = 3
var missiles = max_missiles setget set_missiles

signal player_died
signal player_health_changed(value)
signal player_missiles_changed(value)

func set_health(value):
	if value < health:
		Events.emit_signal("add_screen_shake", shake_amount, 0.5)
	
	health = clamp(value, 0, max_health)
	emit_signal("player_health_changed", value)

	if health == 0:
		emit_signal("player_died")

func set_missiles(value):
	missiles = clamp(value, 0, max_missiles)
	emit_signal("player_missiles_changed", missiles)
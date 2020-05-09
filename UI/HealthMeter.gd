extends Control

var PlayerStats = ResourceLoader.PlayerStats

onready var full = $Full

func _ready():
  PlayerStats.connect("player_health_changed", self, "_on_player_health_changed")

func _on_player_health_changed(value):
  # 5 comes from it being 5 pixels per health bar
  full.rect_size.x = value * 5 + 1

  # doesn't shrink less than 5 pixels so will have to remove to show empty health
  if value <= 0:
	  full.queue_free()

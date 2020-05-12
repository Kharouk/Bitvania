extends HBoxContainer

var PlayerStats = ResourceLoader.PlayerStats

onready var label = $Label

func _ready():
  PlayerStats.connect("player_missiles_changed", self, "_on_player_missile_changed")

func _on_player_missile_changed(amount):
  label.text = str(amount)

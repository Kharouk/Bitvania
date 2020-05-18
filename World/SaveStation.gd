extends StaticBody2D

var PlayerStats = ResourceLoader.PlayerStats

onready var animationPlayer = $AnimationPlayer

func _on_SaveArea_body_entered(_body):
  animationPlayer.play("Save")
  SaverAndLoader.save_game()
  PlayerStats.refill_player_stats()
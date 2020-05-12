extends PowerUp

func _pickup():
  PlayerStats.missiles_unlocked = true
  queue_free()

func respawn_missile():
  # needs to be added
  pass

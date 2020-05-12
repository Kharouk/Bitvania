extends PowerUp

func _pickup():
  PlayerStats.missiles_unlocked = true
  queue_free()

extends PowerUp

func _ready():
  if SaverAndLoader.custom_data.missiles_unlocked:
    queue_free()

func _pickup():
  PlayerStats.missiles_unlocked = true
  SoundFX.play("Powerup", 1, -20)
  queue_free()

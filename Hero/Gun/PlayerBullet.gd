extends "res://Hero/Projectile.gd"

func _ready():
	SoundFX.play("Bullet", rand_range(0.8, 1.1))
	# stops the muzzle flash from following the bullet, stops the process of the parent Projectile
	# once animation starts it sets process back to true
	# don't run the process until animation occurs
	set_process(false)

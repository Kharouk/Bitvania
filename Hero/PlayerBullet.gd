extends "res://Hero/Projectile.gd"

func _ready():
	# stops the muzzle flash from following the bullet, stops the process of the parent Projectile
	# once animation starts it sets process back to true
	set_process(false)

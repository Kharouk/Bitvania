extends Camera2D

var shake = 0

onready var timer = $Timer

func _ready():
	pass

func _process(delta):
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)

func screen_shake(amount, duration):
	shake = amount
	timer.wait_time = duration
	timer.start()

func _on_Timer_timeout():
	shake = 0

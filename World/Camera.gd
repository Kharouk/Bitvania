extends Camera2D

var MainInstances = ResourceLoader.MainInstances
var shake = 0

onready var timer = $Timer


func _ready():
	# warning-ignore:return_value_discarded
	Events.connect("add_screen_shake", self, "_on_Events_add_screen_shake")
	MainInstances.WorldCamera = self

func _process(_delta):
	offset_h = rand_range(-shake, shake)
	offset_v = rand_range(-shake, shake)

func _exit_tree():
	MainInstances.WorldCamera = null

func screen_shake(amount, duration):
	shake = amount
	timer.wait_time = duration
	timer.start()

func _on_Timer_timeout():
	shake = 0

func _on_Events_add_screen_shake(amount, duration):
	screen_shake(amount, duration)

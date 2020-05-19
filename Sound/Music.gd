extends Node

export (Array, AudioStream) var queue = []

var queue_index = 0

onready var musicPlayer = $AudioStreamPlayer

func play_soundtrack():
	assert(queue.size() > 0)
	musicPlayer.stream = queue[queue_index]
	musicPlayer.play()
	queue_index += 1
	if queue_index == queue.size():
		# loops back to the beginning
		queue_index = 0

func queue_stop():
	musicPlayer.stop()

func _on_AudioStreamPlayer_finished():
	play_soundtrack()

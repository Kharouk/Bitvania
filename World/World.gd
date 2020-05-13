extends Node

onready var current_level = $Level_00

func _ready():
	# Sets bg (off-canvas) color black:
	VisualServer.set_default_clear_color(Color.black)

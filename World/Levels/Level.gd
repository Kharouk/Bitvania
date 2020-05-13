extends Node2D

const WORLD = preload("res://World/World.gd")

func _ready():
  var parent = get_parent()

  if parent is WORLD:
	  print("Hello ", WORLD)
	  parent.current_level = self

extends Node2D

const WORLD = preload("res://World/World.gd")

func _ready():
  var parent = get_parent()

  # Hello World!
  if parent is WORLD:
	  parent.currentLevel = self

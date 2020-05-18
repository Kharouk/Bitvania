extends Node

export(String) var sound_string = ""

func _ready():
  if sound_string != "":
    SoundFX.play(sound_string)

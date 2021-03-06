extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	SoundFX.play("Click", 1, -30)
	# warning-ignore:return_value_discarded

	get_tree().change_scene('res://World/World.tscn')
	
	
func _on_LoadButton_pressed():
		SoundFX.play("Click", 1, -30)
		SaverAndLoader.is_loading = true
		# warning-ignore:return_value_discarded
		get_tree().change_scene('res://World/World.tscn')
		# print("new Game now") # TODO : set up alert saying that a new game has started
		

func _on_QuitButton_pressed():
	get_tree().quit()

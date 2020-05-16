extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	# warning-ignore:return_value_discarded
	SaverAndLoader.delete_file()
	get_tree().change_scene('res://World/World.tscn')
	
	
func _on_LoadButton_pressed():
	if (SaverAndLoader.loaded_file):
		SaverAndLoader.is_loading = true
		# warning-ignore:return_value_discarded
		get_tree().change_scene('res://World/World.tscn')
	else:
		print("new Game now") # TODO : set up alert saying that a new game has started
		
		get_tree().change_scene('res://World/World.tscn')
		

func _on_QuitButton_pressed():
	get_tree().quit()

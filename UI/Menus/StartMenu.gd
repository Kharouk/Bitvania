extends Control

func _ready():
	VisualServer.set_default_clear_color(Color.black)

func _on_StartButton_pressed():
	# warning-ignore:return_value_discarded
	get_tree().change_scene('res://World/World.tscn')


func _on_LoadButton_pressed():
	pass 


func _on_QuitButton_pressed():
	get_tree().quit()

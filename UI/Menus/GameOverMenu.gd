extends CenterContainer

func _on_QuitButton_pressed():
	get_tree().quit()


func _on_LoadButton_pressed() -> void:
	SoundFX.play("Click", 1, -30)
	SaverAndLoader.is_loading = false
	Music.list_stop()
	get_tree().change_scene("res://World/World.tscn")

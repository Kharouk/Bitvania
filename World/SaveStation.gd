extends StaticBody2D

onready var animationPlayer = $AnimationPlayer

func _on_SaveArea_body_entered(body):
  animationPlayer.play("Save")
  print("saved")
  SaverAndLoader.save_game()
  SaverAndLoader.retrieve_save_file()
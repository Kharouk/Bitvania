extends Node2D

var velocity = Vector2.ZERO

func _process(delta):
	position += velocity * delta

# warning-ignore:unused_argument -> ignore unused viewport var
func _on_Visibility_viewport_exited(viewport):
	queue_free()

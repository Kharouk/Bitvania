extends Area2D

# the door it connects to, a resource shared between two doors
# the unique connecton between two doors
export(Resource) var connection = null
export(String, FILE, "*.tscn") var new_level_path = ''

var active = true

func _on_Door_body_entered(Hero):
  Hero.emit_signal("hit_door", self)
  active = false

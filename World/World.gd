extends Node

var MainInstances = ResourceLoader.MainInstances

onready var currentLevel = $Level_00

func _ready():
	VisualServer.set_default_clear_color(Color.black)
	MainInstances.Player.connect("hit_door", self, "_on_Hero_hit_door")

func change_levels(door):
	var offset = currentLevel.position
	currentLevel.queue_free()

	var NewLevel = load(door.new_level_path)
	var iNewLevel = NewLevel.instance()
	add_child(iNewLevel)

	var newDoor = get_door_with_connection(door, door.connection)
	var exit_position = newDoor.position - offset
	iNewLevel.position = door.position - exit_position

func get_door_with_connection(entered_door, connection):
	var doors = get_tree().get_nodes_in_group("Door")
	for door in doors:
		if door.connection == connection and door != entered_door:
			return door
	return null


func _on_Hero_hit_door(door):
	# like await:
	call_deferred("change_levels", door)

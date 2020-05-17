extends Node

var custom_data = {
	missiles_unlocked = false,
	boss_defeated = false
}

var is_loading = false

func retrieve_save_file():
	var file = File.new()
	file.open("user://savegame.save", File.READ)
	var _retrieved_file = parse_json(file.get_line())
	file.close()

func delete_file():
	var dir = Directory.new()
	dir.remove("user://savegame.save")
	dir.close()

func save_game():
	var save_file = File.new()
	save_file.open("user://savegame.save", File.WRITE)

	save_file.store_line(to_json(custom_data))

	# if not an empty file:
	if not save_file.eof_reached():
		# gets the first line of the file, parses it, and updates our dictionary
		custom_data = parse_json(save_file.get_line())

	var persistingNodes = get_tree().get_nodes_in_group("Persists")

	for node in persistingNodes:
		var node_data = node.save()
		save_file.store_line(to_json(node_data))

	save_file.close()


func load_game():
	var save_file = File.new()
	if !save_file.file_exists("user://savegame.save"):
		return

	var persistingNodes = get_tree().get_nodes_in_group("Persists")
	for node in persistingNodes:
		node.queue_free()

	save_file.open("user://savegame.save", File.READ)

	while !save_file.eof_reached():
		var line = save_file.get_line()
		if line != null and line.length() > 0:
			var current_line = parse_json(line)
			var newNode = load(current_line["filename"]).instance()
			get_node(current_line["parent"]).add_child(newNode, true)
			newNode.position = Vector2(current_line["position_x"], current_line["position_y"])
	
			for property in current_line.keys():
				if (property == "filename"
				or property == "parent"
				or property == "position_x"
				or property == "property_y"):
					continue # else:
				newNode.set(property, current_line[property])
  
	save_file.close()

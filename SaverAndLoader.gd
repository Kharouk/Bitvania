extends Node

var is_loading = false
var loaded_file = true

func retrieve_save_file():
  var file = File.new()
  file.open("user://savegame.save", File.READ)
  var line = parse_json(file.get_line())
  print("YO: ", line)
  file.close()

func delete_file():
  var dir = Directory.new()
  dir.remove("user://savegame.save")

func save_game():
  var save_file = File.new()
  save_file.open("user://savegame.save", File.WRITE)

  var persistingNodes = get_tree().get_nodes_in_group("Persists")

  for node in persistingNodes:
    var node_data = node.save()
    save_file.store_line(to_json(node_data))
    save_file.close()


func load_game():
  var save_file = File.new()
  if !save_file.file_exists("user://savegame.save"):
    loaded_file = false
    return
  
  var persistingNodes = get_tree().get_nodes_in_group("Persists")
  for node in persistingNodes:
    node.queue_free()

  save_file.open("user://savegame.save", File.READ)

  while !save_file.eof_reached():
    var current_line = parse_json(save_file.get_line())
    if current_line != null:
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

extends Node


func save_game():
  var save_file = File.new()
  save_file.open("user://savegame.save", File.WRITE)

  var persistingNodes = get_tree().get_nodes_in_group("Persists")

  for node in persistingNodes:
    var node_data = node.save()
    save_file.store_line(to_json(node_data))
    save_file.close()


func load_game():
  return
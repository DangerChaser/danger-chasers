extends Node

onready var item_data = read_json("res://data/ItemTable.json")
onready var loot_data = read_json("res://data/LootTable.json")

var inventory_data := { "GOLD" : 0 }


func read_json(file_path : String):
	var file = File.new()
	file.open(file_path, File.READ)
	var json = JSON.parse(file.get_as_text())
	file.close()
	return json.result

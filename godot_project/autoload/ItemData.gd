extends Node

export var item_scene : PackedScene
var _items : Dictionary

func _ready() -> void:
	var item_table  = ImportData.read_json("res://data/ItemTable.json")
	var items_sheet = item_table.Items
	for item_name in items_sheet:
		var item_data = items_sheet[item_name]
		var item = item_scene.instance()
		
		item.name = item_name
		item.description = item_data.description if item_data.description else ""
		
		item.icon = load("res://assets/item_icons/" + item_data.icon_name)
		
		item.type = item_data.type if item_data.type else "miscellaneous"
		item.subtype = item_data.subtype if item_data.subtype else ""
		item.stack = item_data.stack if item_data.stack else false
		item.rarity = item_data.rarity if item_data.rarity else "common"
		item.quality = item_data.quality if item_data.quality else "normal"
		item.level = item_data.level if item_data.level else 1
		
		add_child(item)
		_items[item.name] = item


func get_item(item_name : String) -> Item:
	if not _items.has(item_name):
		return null
	
	var item = _items[item_name].clone()
	return item

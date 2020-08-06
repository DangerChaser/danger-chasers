extends Control
class_name LootPanel

onready var loot_slots := $Background/VBoxContainer/MainElements/LootSlots/VBoxContainer

export var item_button : PackedScene

var loot_data
var loot_dictionary = {}


func enable(table_name : String) -> void:
	loot_data = ImportData.loot_data[table_name]
	var loot_count = _determine_loot_count()
	_loot_selector(loot_count)
	_populate_panel(loot_count)



func _determine_loot_count() -> int:
	var item_count_min = loot_data.ItemCountMin
	var item_count_max = loot_data.ItemCountMax
	randomize()
	return randi() % ((int(item_count_max) - int(item_count_min) + 1) + int(item_count_min))


func _loot_selector(loot_count : int) -> void:
	randomize()
	for i in range(0, loot_count):
		var loot_selector = randi() % 100 + 1
		var counter = 0
		while loot_selector >= 0:
			if loot_selector <= loot_data["Item" + str(counter) + "Chance"]:
				var loot = []
				loot.append(loot_data["Item" + str(counter) + "Name"])
				var min_quantity = float(loot_data["Item" + str(counter) + "MinQ"])
				var max_quantity = float(loot_data["Item" + str(counter) + "MaxQ"])
				loot.append((int(rand_range(min_quantity, max_quantity))))
				loot_dictionary[loot_dictionary.size() + 1] = loot
				break
			else:
				loot_selector -= loot_data["Item" + str(counter) + "Chance"]
				counter += 1


func _populate_panel(loot_count : int) -> void:
	var counter = loot_dictionary.size()
	for i in range(0, counter):
		var new_item_button = item_button.instance()
		var item_name = loot_dictionary[i + 1][0]
		var icon = "res://items/icons/" + str(item_name) + ".png"
		var quantity = loot_dictionary[i + 1][1]
		loot_slots.add_child(new_item_button)
		new_item_button.initialize(item_name, icon, quantity, i)


func loot(loot_slot : int):
	loot_slot += 1
	if loot_dictionary.has(loot_slot):
		if loot_dictionary[loot_slot][0] == "GOLD":
			ImportData.inventory_data.GOLD += loot_dictionary[loot_slot][1]

extends Node

var inventory := { "miscellaneous" : {},
						"key" : {},
						"weapon" : {},
						"armor" : {}}

var gold := 0


func add_gold(amount := 1) -> void:
	gold += amount


func remove_gold(amount := 1) -> void:
	gold -= amount


func has(item_name : String, required_amount := 1) -> bool:
	for type_inventory in inventory:
		if not type_inventory.has(item_name):
			continue
		if type_inventory[item_name] >= required_amount:
			return true
	return false


func add(item_name : String, amount:=1) -> void:
	var item = ItemData.get_item(item_name)
	if not item:
		return
	
	var type_inventory = inventory[item.type]
	if type_inventory.has(item.name):
		type_inventory[item.name] += amount
	else:
		type_inventory[item.name] = amount


func remove(item_name : String, amount:=1) -> void:
	if not ItemData.items.has(item_name):
		return
	
	var item = ItemData.get_item(item_name)
	var type_inventory = inventory[item.type]
	if type_inventory.has(item.name):
		if type_inventory[item.name] < amount:
			print_debug("Tried to remove " + str(amount) + " from " + item.name + ", but only has "  + str(type_inventory[item.name]))
		else:
			type_inventory[item.name] -= amount
			if type_inventory[item.name] == 0:
				type_inventory.erase(item.name)
	else:
		print_debug("Has no item " + item_name + " to remove")

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
	var item = ItemData.get(item_name)
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
	
	var item = ItemData.get(item_name)
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


func save_data() -> void:
	var file = File.new()
	var file_name = GameManager.save_folder + "inventory.dat"
	var error = file.open(file_name, File.WRITE)
	if not error == OK:
		print_debug("Error opening " + file_name + ".")
		return
	
	file.store_var(inventory)
	file.store_var(gold)
	file.close()


func load_data() -> void:
	var file = File.new()
	var file_name = GameManager.save_folder + "inventory.dat"
	if not file.file_exists(file_name):
		print_debug("File " + file_name + " does not exist.")
		return
	
	var error = file.open(file_name, File.READ)
	if not error == OK:
		print_debug("Error opening " + file_name + ".")
		return
	inventory = file.get_var()
	gold = file.get_var()
	file.close()

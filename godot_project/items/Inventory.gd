extends Control

signal closed

onready var gold_label := $Background/VBoxContainer/MainElements/Tabs/Gold/KeyLabel
onready var item_button_container : VBoxContainer = $Background/VBoxContainer/MainElements/ItemList/VBoxContainer
onready var item_inspector_container : VBoxContainer = $Background/VBoxContainer/MainElements/ItemInspector
onready var item_icon_rect : TextureRect = $Background/VBoxContainer/MainElements/ItemInspector/HBoxContainer/ItemIcon
onready var item_name_label : KeyLabel = $Background/VBoxContainer/MainElements/ItemInspector/HBoxContainer/ItemName
onready var item_description_label : KeyLabel = item_inspector_container.find_node("ItemDescription")
onready var tabs := $Background/VBoxContainer/MainElements/Tabs

onready var weapons_tab_button := tabs.find_node("Weapons")
onready var armor_tab_button := tabs.find_node("Armor")
onready var keys_tab_button := tabs.find_node("Keys")
onready var other_tab_button := tabs.find_node("Other")

export var item_button_scene : PackedScene

var active : bool = false
var current_tab_button


func _ready():
	hide()
	current_tab_button = tabs.get_child(0)


func disable() -> void:
	active = false
	emit_signal("closed")
	visible = false


func enable() -> void:
	active = true
	gold_label.text = str(InventoryData.gold)
	visible = true
	current_tab_button.grab_focus()


func _input(event):
	if event.is_action_pressed("open_inventory"):
		if not active:
			enable()
		else:
			disable()


func _on_CloseButton_button_down():
	disable()


func _on_Weapons_button_down():
	var inventory = InventoryData.inventory["weapon"]
	show_item_list(inventory)
	current_tab_button = weapons_tab_button


func _on_Armor_button_down():
	var inventory = InventoryData.inventory["armor"]
	show_item_list(inventory)
	current_tab_button = armor_tab_button


func _on_Keys_button_down():
	var inventory = InventoryData.inventory["key"]
	show_item_list(inventory)
	current_tab_button = keys_tab_button


func _on_Other_button_down():
	var inventory = InventoryData.inventory["miscellaneous"]
	show_item_list(inventory)
	current_tab_button = other_tab_button


func show_item_list(inventory : Dictionary) -> void:
	for child in item_button_container.get_children():
		child.queue_free()
	
	for item_name in inventory.keys():
		var item = ItemData.get(item_name)
		if item.stack:
			var item_button = item_button_scene.instance()
			item_button_container.add_child(item_button)
			item_button.initialize(item.name, item.icon, inventory[item.name])
			item_button.connect("button_down", self, "show_item_info")
			item_button.button.grab_focus()
		else:
			for i in range(0, inventory[item.name]):
				var item_button = item_button_scene.instance()
				item_button_container.add_child(item_button)
				item_button.initialize(item.name, item.icon, 1)
				item_button.connect("button_down", self, "show_item_info")
	if item_button_container.get_child_count() > 0:
		item_button_container.get_child(0).button.grab_focus()


func show_item_info(name : String) -> void:
	var item = ItemData.get(name)
	_show_item_info(item.name, item.icon, item.description)


func _show_item_info(name : String, icon : Texture, description : String) -> void:
	item_name_label.set_key(name)
	item_icon_rect.texture = icon
	item_description_label.set_key(description)

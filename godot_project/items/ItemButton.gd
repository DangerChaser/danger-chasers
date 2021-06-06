extends Control

signal button_down(item_name)

onready var button : Button = $Button
onready var item_background : TextureRect = $HBoxContainer/VBoxContainer/ItemBackground
onready var item_name_label : KeyLabel = $HBoxContainer/ItemNameLabel
onready var quantity_label : KeyLabel = item_background.get_node("QuantityLabel")

var item : Item

func _ready() -> void:
	quantity_label.visible = false


func initialize(item : Item, quantity := 1) -> void:
	self.item = item
	item_name_label.set_key(item.name)
	item_background.texture = item.icon
	if item.stack and quantity > 1:
		quantity_label.text = str(quantity)
		quantity_label.visible = true


func _on_Button_button_down():
	emit_signal("button_down", item.name)

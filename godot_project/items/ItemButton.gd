extends Control

signal button_down(item_name)

onready var button : Button = $Button
onready var item_background : TextureRect = $HBoxContainer/ItemBackground
onready var item_name_label : KeyLabel = $HBoxContainer/ItemNameLabel
onready var quantity_label : KeyLabel = $HBoxContainer/ItemBackground/QuantityLabel

var item_name : String

func _ready() -> void:
	quantity_label.visible = false


func initialize(item_name : String, icon : Texture, quantity : int) -> void:
	self.item_name = item_name
	item_name_label.set_key(item_name)
	item_background.texture = icon
	if quantity > 0:
		quantity_label.text = str(quantity)
		quantity_label.visible = true


func _on_Button_button_down():
	emit_signal("button_down", item_name)

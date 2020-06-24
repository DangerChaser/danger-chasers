extends HBoxContainer


onready var item_background := $ItemBackground
onready var item_name_label : KeyLabel = $ItemNameLabel
onready var quantity_label : KeyLabel = $ItemBackground/ItemButton/QuantityLabel

var loot_slot

func _ready() -> void:
	quantity_label.visible = false


func initialize(item_name : String, icon : Texture, quantity : int, loot_slot_number : int) -> void:
	item_name_label.set_key(item_name)
	if quantity > 0:
		quantity_label.text = str(quantity)
		quantity_label.visible = true
	loot_slot = loot_slot_number

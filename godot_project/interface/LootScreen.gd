extends Control

signal finished
export var item_button : PackedScene

onready var item_list : VBoxContainer = $ItemList


func _ready():
	set_process_input(false)
	$ContinueLabel.visible = false

# items --> Dictionary of { "item_name" : String : "item_quantity" : int }
func initialize(items : Dictionary) -> void:
	for item in items.keys():
		yield(get_tree().create_timer(1.0), "timeout")
		var item_data = ItemData.get(item)
		var new_item_button = item_button.instance()
		item_list.add_child(new_item_button)
		new_item_button.initialize(item_data, items[item])
		$Sfx.play()
	
	yield(get_tree().create_timer(1.0), "timeout")
	set_process_input(true)
	$ContinueLabel.visible = true


func _input(event):
	if event.is_action_type():
		emit_signal("finished")
		set_process_input(false)

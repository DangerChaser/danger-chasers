extends Control

signal closed

onready var gold_label := $Background/VBoxContainer/MainElements/Tabs/Gold/KeyLabel

export var item_button : PackedScene

var active : bool = false


func _ready():
	hide()


func disable() -> void:
	hide()
	active = false
	emit_signal("closed")


func enable() -> void:
	gold_label.text = str(ImportData.inventory_data.GOLD)
	show()
	active = true


func _input(event):
	if event.is_action_pressed("open_inventory"):
		if not active:
			enable()
		else:
			disable()


func _on_CloseButton_button_down():
	disable()

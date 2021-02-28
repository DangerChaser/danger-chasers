extends HBoxContainer

signal change_button_pressed
signal key_changed(action_name, key)

onready var button_key : ButtonKey = $ButtonKey

var action_name : String

func _ready() -> void:
	set_process_input(false)

func initialize(action_name, key, can_change):
	self.action_name = action_name
	$Action.text = action_name.capitalize()
	$ButtonKey.text = OS.get_scancode_string(key)
	$ButtonKey.disabled = not can_change

func update_key(scancode):
	$ButtonKey.text = OS.get_scancode_string(scancode)

func _on_ButtonKey_pressed():
	set_process_input(true)
	$ButtonKey.set_key("PRESS ANY BUTTON")
	emit_signal('change_button_pressed')


func _input(event):
	if not event.is_pressed():
		return
	update_key(event.scancode)
	emit_signal("key_changed", action_name, event.scancode)
	set_process_input(false)

extends HBoxContainer

signal change_button_pressed

func initialize(action_name, key, can_change):
	$Action.text = action_name.capitalize()
	$ButtonKey.text = OS.get_scancode_string(key)
	$ButtonKey.disabled = not can_change

func update_key(scancode):
	$ButtonKey.text = OS.get_scancode_string(scancode)

func _on_ButtonKey_pressed():
	emit_signal('change_button_pressed')

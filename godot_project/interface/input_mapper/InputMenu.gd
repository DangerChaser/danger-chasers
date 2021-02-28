extends Control
class_name InputMenu

signal finished

onready var input_mapper := $InputMapper
onready var _action_list = $Column/ScrollContainer/ActionList


func _on_InputMapper_mappings_set(mappings : Dictionary):
	$Column/ScrollContainer/ActionList.clear()
	for action in mappings.keys():
		var line = $Column/ScrollContainer/ActionList.add_input_line(action, mappings[action])
		line.connect('change_button_pressed', self, 'set_process_input', [false])
		line.connect('key_changed', self, '_on_InputLine_key_changed')


func _on_InputLine_key_changed(action_name, key_scancode):
	input_mapper.change_action_key(action_name, key_scancode)
	set_process_input(true)

func _input(event):
	if event.is_action_pressed('ui_cancel'):
		disable()
		emit_signal("finished")

func _on_BackButton_pressed():
	disable()
	emit_signal("finished")


func enable() -> void:
	set_process_input(true)
	visible = true


func disable() -> void:
	set_process_input(false)
	visible = false


func _on_ResetButton_pressed():
	input_mapper.reset()

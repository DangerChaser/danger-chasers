extends Node

signal mappings_set(mappings)

var default_mappings = {
	'ui_up': KEY_UP,
	'ui_down': KEY_DOWN,
	'ui_left': KEY_LEFT,
	'ui_right': KEY_RIGHT,
	'light_attack': KEY_Z,
	'interact': KEY_F,
	'pause': KEY_ESCAPE,
	'skill_1': KEY_A,
	'skill_2': KEY_S,
	'skill_3': KEY_D,
	'skill_4': KEY_F,
	'skill_5': KEY_Q,
	'skill_6': KEY_W,
	'skill_7': KEY_E,
	'skill_8': KEY_R,
	'skill_9': KEY_V,
}
var mappings = default_mappings


func _ready() -> void:
	load_data()
	for action in mappings:
		change_action_key(action, mappings[action])
	emit_signal("mappings_set", mappings)

func change_action_key(action_name, key_scancode):
	_erase_action_events(action_name)
	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	mappings[action_name] = key_scancode
	emit_signal("mappings_set", mappings)

func _erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func reset() -> void:
	mappings = default_mappings
	for action in mappings:
		change_action_key(action, mappings[action])


func save_data() -> void:
	var file = File.new()
	var file_name = GameManager.USER_DIR + "input_settings.dat"
	var error = file.open(file_name, File.WRITE)
	if not error == OK:
		print_debug("Error opening " + file_name + ".")
		return
	
	file.store_var(mappings)
	file.close()


func load_data() -> void:
	var file = File.new()
	var file_name = GameManager.USER_DIR + "input_settings.dat"
	if not file.file_exists(file_name):
		print_debug("File " + file_name + " does not exist.")
		return
	
	var error = file.open(file_name, File.READ)
	if not error == OK:
		print_debug("Error opening " + file_name + ".")
		return
	
	var data : Dictionary = file.get_var()
	for key in data.keys():
		mappings[key] = data[key]
	
	file.close()

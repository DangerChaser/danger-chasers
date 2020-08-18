extends Node

signal profile_changed(new_profile, is_customizable)

var current_profile_id = 0
var profiles = {
	0: 'profile_normal',
	#1: 'profile_alternate',
	1: 'profile_custom',
}
var profile_normal = {
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
var profile_alternate = {
	#'move_up': KEY_W,
	#'move_down': KEY_S,
	#'move_left': KEY_A,
	#'move_right': KEY_D
}
var profile_custom = profile_normal

func change_profile(id):
	current_profile_id = id
	var profile = get(profiles[id])
	var is_customizable = true if profiles[id] == 'profile_custom' else false
	
	for action_name in profile.keys():
		change_action_key(action_name, profile[action_name])
	emit_signal('profile_changed', profile, is_customizable)
	return profile

func change_action_key(action_name, key_scancode):
	erase_action_events(action_name)

	var new_event = InputEventKey.new()
	new_event.set_scancode(key_scancode)
	InputMap.action_add_event(action_name, new_event)
	get_selected_profile()[action_name] = key_scancode

func erase_action_events(action_name):
	var input_events = InputMap.get_action_list(action_name)
	for event in input_events:
		InputMap.action_erase_event(action_name, event)

func get_selected_profile():
	return get(profiles[current_profile_id])

func _on_ProfilesMenu_item_selected(ID):
	change_profile(ID)

extends Node2D
class_name StateMachine

signal state_changed(states)

export var initial_args : Dictionary = {}.duplicate() # Duplicate to avoid all shared instances from sharing the same dictionary

var states_map : Dictionary = {}
var states_stack : Array = []
var can_change_state := true


func _ready():
	for state in get_children():
		state.set_owner(owner)
		states_map[state.name] = state
		state.connect("finished", self, "change_state")


func initialize() -> void:
	assert (get_child_count() > 0)
	for state in states_stack:
		state.exit()
	states_stack.clear()
	
	var initial_state = get_child(0)
	states_stack.push_front(initial_state)
	states_stack[0].enter(initial_args)


func get_state(state_name : String) -> State:
	if has_state(state_name):
		var state : State = states_map[state_name]
		return state
	else:
		return null


func change_state(state_override := "", args := {}) -> void:
	if not can_change_state:
		return
	states_stack[0].exit()
	
	var new_state
	if state_override:
		if state_override == "previous":
			states_stack.pop_front()
			new_state = states_stack[0]
		else:
			new_state = get_state(state_override)
			if new_state.pushdown:
				states_stack.push_front(new_state)
	else:
		new_state = _decide_on_next_state()
	
	states_stack[0] = new_state
	
	emit_signal("state_changed", states_stack)
	states_stack[0].enter(args)

"'Virtual function, dependent on specific state machines'"
func _decide_on_next_state() -> State:
	return null


func get_current_state() -> State:
	return states_stack[0]


func _ai_check() -> void:
	var target = owner.target.get_target()


func anim_finished(anim_name : String) -> void:
	if states_stack.size() > 0:
		get_current_state().anim_finished(anim_name)


func has_state(state_name : String) -> bool:
	return states_map.has(state_name)


func unpause() -> void:
	get_current_state().unpause()


func pause() -> void:
	get_current_state().pause()


func enable_state_change() -> void:
	can_change_state = true


func disable_state_change() -> void:
	can_change_state = false

extends Node2D
class_name StateMachine

signal state_exited(state_name)
signal state_entered(state_name)
signal state_changed(states)

export var initial_args : Dictionary = {}.duplicate() # Duplicate to avoid all shared instances from sharing the same dictionary

var current_state : State
var can_change_state := true


func _ready():
	for state in get_children():
		state.set_owner(owner)
		state.connect("finished", self, "change_state")


func initialize() -> void:
	assert (get_child_count() > 0)
	change_state(get_child(0).name, initial_args)


func get_state(state_name : String) -> State:
	if has_state(state_name):
		var state : State = get_node(state_name)
		return state
	else:
		return null


func change_state(state_override := "", args := {}) -> void:
	if not can_change_state:
		return
	
	if current_state:
		current_state.exit()
		emit_signal("state_exited", current_state.name)
	current_state = get_state(state_override) if state_override else _decide_on_next_state()
	current_state.enter(args)
	emit_signal("state_entered", current_state.name)
	emit_signal("state_changed", current_state)

"'Virtual function, dependent on specific state machines'"
func _decide_on_next_state() -> State:
	return null


func get_current_state() -> State:
	return current_state


func _ai_check() -> void:
	var target = owner.target.get_target()


func anim_finished(anim_name : String) -> void:
	if current_state:
		current_state.anim_finished(anim_name)


func has_state(state_name : String) -> bool:
	return has_node(state_name)


func unpause() -> void:
	if current_state:
		current_state.unpause()


func pause() -> void:
	if current_state:
		current_state.pause()


func enable_state_change() -> void:
	can_change_state = true


func disable_state_change() -> void:
	can_change_state = false


func add_child(node, legible_unique_name := false) -> void:
	assert(node is State)
	.add_child(node, legible_unique_name)
	node.set_owner(owner)
	node.connect("finished", self, "change_state")

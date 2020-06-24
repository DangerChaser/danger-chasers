extends State

export(String) var next_state : String = ""
var state_active = null

func _ready() -> void:
	for state in get_children():
		state.connect("finished", self, "_on_active_state_finished")


func enter(args := {}) -> void:
	state_active = get_child(0)
	state_active.enter(args)


func exit() -> void:
	if state_active:
		state_active.exit()
		state_active = null


func anim_finished(anim_name : String) -> void:
	state_active.anim_finished(anim_name)


func _on_active_state_finished(state_override : String = "", args :={}) -> void:
	if state_override:
		finished(state_override, args)
		return
	go_to_next_state_in_sequence(args)


func go_to_next_state_in_sequence(args :={}) -> void:
	state_active.exit()
	var new_state_index = (state_active.get_index() + 1) % get_child_count()
	if new_state_index == 0:
		finished(next_state, args)
		return
	state_active = get_child(new_state_index)
	state_active.enter(args)


func take_damage(args := {}):
	state_active.take_damage(args)

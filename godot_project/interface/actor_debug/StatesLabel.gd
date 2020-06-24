extends Label

func update_label(states_stack : Array) -> void:
	assert (states_stack[0] is State)
	text = "States\n"
	for i in range(states_stack.size()):
		text += "%s. %s\n" % [i, states_stack[i].name]

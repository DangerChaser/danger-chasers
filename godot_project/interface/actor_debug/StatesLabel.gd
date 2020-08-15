extends Label

func update_label(state : State) -> void:
	text = "State: %s\n" % [state.name]

extends Position2D

func initialize(actor) -> void:
	actor.get_node("StateMachine").initial_args["target_position"] = global_position
	#actor.get_node("StateMachine").initial_args["disable_collider_in_state"] = true

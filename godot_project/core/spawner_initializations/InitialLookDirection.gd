extends Position2D

export(Vector2) var look_direction := Vector2(1, 0)

func initialize(actor) -> void:
	actor.get_node("StateMachine").initial_args["look_direction"] = look_direction
	actor.get_node("StateMachine").initial_args["target_direction"] = look_direction
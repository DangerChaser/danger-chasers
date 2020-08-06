extends InteractableScript

export(String) var transition_in_animation : String
export(float) var transition_in_duration := 1.0

func interact(actor) -> void:
	.interact(actor)
	yield(Transition.transition_in(transition_in_animation, transition_in_duration), "transition_in_finished")
	get_tree().quit()

extends InteractableScript


export(String) var level_path : String
export(int) var spawn_point : int = 0
export(String) var transition_in_animation : String
export(float) var transition_in_duration := 0.2


func interact(actor) -> void:
	.interact(actor)
	
	GameManager.level.request_change(level_path, spawn_point, transition_in_animation, transition_in_duration)

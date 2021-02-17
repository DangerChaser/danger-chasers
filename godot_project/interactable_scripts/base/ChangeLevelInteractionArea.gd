extends InteractionArea

export var level_path : String
export var spawn_point : int = 0
export var transition_in_animation : String
export var transition_in_duration := 0.2

func change(anim_name):
	GameManager.level.request_change(level_path, spawn_point, transition_in_animation, transition_in_duration)


func interact() -> void:
	.interact()
	PlayerManager.hide_player_hud()
	PlayerManager.disable_input()

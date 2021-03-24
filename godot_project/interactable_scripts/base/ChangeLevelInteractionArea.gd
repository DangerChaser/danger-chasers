extends InteractionArea

export var level_path : String
export var spawn_point : int = 0
export var transition_in_animation : String
export var transition_in_duration := 0.2
export var player_animation := "hand_reach"

onready var player_manager : PlayerManagedStateManager = $PlayerManagedStateManager

func change(anim_name):
	GameManager.level.request_change(level_path, spawn_point, transition_in_animation, transition_in_duration)


func interact() -> void:
	.interact()
	if is_locked:
		return
	
	player_manager.hide_player_hud()
	player_manager.disable_input()
	player_manager.play_animation(player_animation)
	player_manager.face_actor(self)

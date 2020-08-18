extends ActorManagedStateManager

export var face_target_node_path : NodePath


func enable() -> void:
	actor = PlayerManager.player
	.enable()

func disable() -> void:
	actor = PlayerManager.player
	.disable()

func play_animation(anim_name : String) -> void:
	actor = PlayerManager.player
	.play_animation(anim_name)

func face_actor(target_actor=null):
	actor = PlayerManager.player
	if not target_actor:
		if face_target_node_path:
			target_actor = get_node(face_target_node_path)
	.face_actor(target_actor)

func enable_input() -> void:
	actor = PlayerManager.player
	.enable_input()

func disable_input() -> void:
	actor = PlayerManager.player
	.disable_input()

func enable_activation_scanner() -> void:
	actor = PlayerManager.player
	actor.activation_scanner.enable()

func disable_activation_scanner() -> void:
	actor = PlayerManager.player
	actor.activation_scanner.disable()

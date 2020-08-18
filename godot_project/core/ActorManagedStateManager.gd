extends Node2D
class_name ActorManagedStateManager

export var actor_path : NodePath
export var managed_state : PackedScene
var actor : Actor



func _ready() -> void:
	if actor_path:
		actor = get_node(actor_path)

func enable() -> void:
	if not actor:
		return
	var state : ManagedState = managed_state.instance()
	actor.state_machine.add_child(state)
	actor.state_machine.change_state(state.name, {"manager": self})
	actor.disable_input()

func disable() -> void:
	if not actor:
		return
	
	actor.state_machine.get_current_state().finished()
	actor.enable_input()

func play_animation(anim_name : String) -> void:
	if not actor:
		return
	actor.play_animation(anim_name)

func face_actor(target_actor=null):
	if not actor:
		return
	actor.face_actor(target_actor)
	global_position = actor.global_position
	scale = actor.scale
	set_rotation(actor.rotation)

func disable_input() -> void:
	if not actor:
		return
	actor.disable_input()

func enable_input() -> void:
	if not actor:
		return
	actor.enable_input()

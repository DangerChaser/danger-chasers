extends Node2D
class_name ManagedStateManager

export var actor_path : NodePath
export var managed_state : PackedScene
onready var actor := get_node(actor_path)


func enable() -> void:
	var state : ManagedState = managed_state.instance()
	actor.state_machine.add_child(state)
	actor.state_machine.change_state(state.name, {"manager": self})

func disable() -> void:
	actor.state_machine.get_current_state().finished()

func play_animation(anim_name : String) -> void:
	actor.play_animation(anim_name)

func face_actor(target_actor=null):
	actor.face_actor(target_actor)
	global_position = actor.global_position
	scale = actor.scale
	set_rotation(actor.rotation)

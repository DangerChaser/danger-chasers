extends Node2D
class_name ActorManagedStateManager

export var actor_path : NodePath
export var managed_state : PackedScene
var actor : Actor
var state : ManagedState



func _ready() -> void:
	if actor_path:
		actor = get_node(actor_path)

func enable() -> void:
	if not actor:
		return
	state = managed_state.instance()
	actor.state_machine.add_child(state)
	actor.state_machine.change_state(state.name, {"manager": self})
	actor.disable_input()

func disable() -> void:
	if not actor:
		return
	
	if state and actor.state_machine.get_current_state() == state:
		state.finished()
	actor.enable_input()


func change_state(state : String) -> void:
	actor.state_machine.change_state(state)


func play_animation(anim_name : String) -> void:
	if not actor:
		return
	actor.play_animation(anim_name)

func face_actor(target_actor=null):
	if not actor or not target_actor:
		return
	actor.face_object(target_actor)
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

func queue_free_actor() -> void:
	if not actor:
		return
	actor.queue_free()
	actor = null


func go_to_actor() -> void:
	if not actor:
		return
	global_position = actor.global_position


func initialize(team := "") -> void:
	if not actor:
		return
	actor.initialize(team)

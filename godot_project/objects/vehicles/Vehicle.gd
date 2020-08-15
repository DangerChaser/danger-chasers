extends State
class_name Vehicle

onready var pivot := $Pivot
onready var tween : Tween = $Tween
onready var state_machine : StateMachine = $StateMachine
onready var camera_limit_trigger : CameraLimitTrigger = $CameraLimitTrigger

export var animation := ""
export var owner_animation := ""

var camera_zoom : Vector2
var animation_player : AnimationPlayer


func _ready():
	set_physics_process(false)
	set_process_input(false)
	
	if has_node("Pivot/AnimationPlayer"):
		animation_player = get_node("Pivot/AnimationPlayer")


func enter(args := {}) -> void:
	.enter(args)
	camera_limit_trigger.change()
	
	if animation_player and animation_player.has_animation(animation):
		animation_player.play(animation)
	owner.play_animation(owner_animation)
	owner.set_rotation(rotation)
	
	set_physics_process(true)
	set_process_input(true)


func exit() -> void:
	.exit()
	if animation_player and animation_player.has_animation("exit"):
		animation_player.play("exit")
	camera_limit_trigger.reset()
	
	queue_free()

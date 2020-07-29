extends Node2D

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sfx : AudioStreamPlayer2D = $Sfx

export var state_to_switch_to := "Air"
export var force := 9001.0
export var mass := 42.0
export var input_disabled_duration := 0.1
export var animation := "jump"


func _ready() -> void:
	animation_player.play("SETUP")


func _on_CollisionTrigger_area_entered(area):
	if not area.owner is Actor:
		return
	
	animation_player.play("launch")
	sfx.play()
	
	var actor = area.owner
	var state_machine = actor.state_machine
	if state_machine.has_state(state_to_switch_to):
		var direction = Vector2.UP.rotated(global_rotation)
		var external_args = {
			"velocity" : direction * force,
			"target_direction" : direction,
			"target_speed" : 0.0,
			"mass" : mass
		}
		state_machine.change_state(state_to_switch_to, {"gravity_speed" : 0.0, "animation" : animation, "external" : external_args})
		state_machine.disable_state_change()
		yield(get_tree().create_timer(input_disabled_duration), "timeout")
		state_machine.enable_state_change()

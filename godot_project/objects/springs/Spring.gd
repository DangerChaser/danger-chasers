extends Node2D

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var sfx : AudioStreamPlayer2D = $Sfx

export(String) var state_to_switch_to := "Air"
export(float) var force := 5000.0
export(float) var input_disabled_duration := 0.1
export(String) var animation := "jump"


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
		state_machine.change_state(state_to_switch_to, {"gravity_speed" : - force, "animation" : animation})
		state_machine.disable_state_change()
		yield(get_tree().create_timer(input_disabled_duration), "timeout")
		state_machine.enable_state_change()

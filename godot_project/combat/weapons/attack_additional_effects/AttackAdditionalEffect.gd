extends Node2D
class_name AttackAdditionalEffect

signal finished

var weapon
var attack

func _ready() -> void:
	pause()

func enter(args := {}) -> void:
	if not owner.target.get_target():
		owner.target.lock_on()
	unpause()

func exit() -> void:
	pause()

func get_exit_args() -> Dictionary:
	return {}

func pause() -> void:
	set_process(false)
	set_physics_process(false)
	set_process(false)
	set_process_input(false)

func unpause() -> void:
	set_process(true)
	set_physics_process(true)
	set_process(true)
	set_process_input(true)

func finished(next_state:="", args:={}):
	emit_signal("finished", next_state, args)

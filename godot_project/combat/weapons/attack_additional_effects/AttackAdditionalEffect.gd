extends Node2D
class_name AttackAdditionalEffect

signal finished

var weapon

func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process(false)
	set_process_input(false)

func enter(args := {}) -> void:
	set_process(true)
	set_physics_process(true)
	set_process(true)
	set_process_input(true)

func exit() -> void:
	set_process(false)
	set_physics_process(false)
	set_process(false)
	set_process_input(false)

func get_exit_args() -> Dictionary:
	return {}

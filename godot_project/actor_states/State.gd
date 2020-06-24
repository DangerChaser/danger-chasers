extends Node2D
class_name State

signal entered
signal finished(next_state_name)

export var pushdown : bool = false


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func enter(args := {}) -> void:
	set_process(true)
	set_physics_process(true)
	emit_signal("entered")
	if owner.is_in_group("players"):
		set_process_input(true)

func exit() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)


func anim_finished(anim_name : String) -> void:
	pass


func take_damage(args := {}):
#	emit_signal("finished", "Stagger", args)
	pass


func set_owner(_owner) -> void:
	owner = _owner
	for child in get_children():
		child.set_owner(_owner)


func finished(next_state:="", args:={}):
	emit_signal("finished", next_state, args)

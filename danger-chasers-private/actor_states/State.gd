extends Node2D
class_name State

signal entered
signal finished(next_state_name)
signal exited

export var pushdown : bool = false

var finished_flag := false
var finished_next_state := ""
var finished_args := {}
var paused := false


func _ready() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)

func enter(args := {}) -> void:
	set_process(true)
	set_physics_process(true)
	if owner.is_in_group("players"):
		set_process_input(true)
	emit_signal("entered")

func exit() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	emit_signal("exited")


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
	if paused:
		finished_flag = true
		finished_next_state = next_state
		finished_args = args
		return
	
	emit_signal("finished", next_state, args)


func pause() -> void:
	set_process(false)
	set_physics_process(false)
	set_process_input(false)
	paused = true


func unpause() -> void:
	set_process(true)
	set_physics_process(true)
	if owner.is_in_group("players"):
		set_process_input(true)
	paused = false
	
	if finished_flag:
		finished_flag = false
		emit_signal("finished", finished_next_state, finished_args)

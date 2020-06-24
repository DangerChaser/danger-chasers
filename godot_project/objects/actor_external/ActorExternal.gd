extends Node2D
class_name ActorExternal

signal finished(next_state, args)


func enter(args:={}) -> void:
	pass


func exit() -> void:
	pass


func finished(next_state := "", args :={}) -> void:
	emit_signal("finished", next_state, args)


func set_owner(_owner) -> void:
	owner = _owner
	Utilities.set_all_children_owner(self)

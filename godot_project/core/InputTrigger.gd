extends Node2D


signal triggered

export var input : String
export var active_after_trigger := false


func _ready() -> void:
	set_process_input(false)

func enable() -> void:
	set_process_input(true)

func _input(event):
	if event.is_action_pressed(input):
		emit_signal("triggered")
		if not active_after_trigger:
			set_process_input(false)

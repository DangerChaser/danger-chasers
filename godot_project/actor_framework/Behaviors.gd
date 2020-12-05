extends Node2D

signal input_event_received(event)

func _input(event):
	emit_signal("input_event_received", event)

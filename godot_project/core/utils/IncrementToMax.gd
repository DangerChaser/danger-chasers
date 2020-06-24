extends Node

signal finished

export(int) var max_i : int = 1
var i : int = 0

func _ready() -> void:
	reset()

func reset() -> void:
	i = 0

func increment(var dummy=null):
	i += 1
	if i >= max_i:
		emit_signal("finished")

func decrement():
	i -= 1
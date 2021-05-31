extends Node2D
class_name ResourceStat

signal value_changed(value, max_value)

export var max_value : int = 100
export var value : int = 0 setget set_value


func _ready() -> void:
	reset()


func reset() -> void:
	self.value = 0

func set_value(new_value):
	value = new_value
	emit_signal("value_changed", value, max_value)

func add_value(increment_value := 1) -> void:
	self.value = min(value + increment_value, max_value)

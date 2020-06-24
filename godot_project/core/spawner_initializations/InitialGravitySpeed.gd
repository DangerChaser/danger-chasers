extends Node2D

export(float) var gravity_speed := 1400.0

func initialize(object) -> void:
	object.get_node("Motion/Gravity").speed = gravity_speed
extends Node


export var engine_speed := 1.0

func enable() -> void:
	Engine.time_scale = engine_speed


func disable() -> void:
	Engine.time_scale = 1.0

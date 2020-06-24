extends Node

signal change_requested(level_path, target_spawn_point)

export(int) var target_spawn_point : int = 0
export(String) var level_path : String

func request_change():
	emit_signal("change_requested", level_path, target_spawn_point)
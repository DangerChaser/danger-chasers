extends Node
class_name RoundManager

signal round_started(round_number)

export(Array, int) var actor_group_round_thresholds : Array = []

var current_round = 0


func next_round() -> void:
	current_round += 1
	emit_signal("round_started", current_round)


func get_group(value : int) -> int:
	if actor_group_round_thresholds.size() == 0:
		return value
	var i = 0
	for threshold in actor_group_round_thresholds:
		if value < threshold:
			return i
		else:
			i += 1
	return i

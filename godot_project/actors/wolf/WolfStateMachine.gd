extends StateMachine

export var attack_distance := 900.0
export var attack_chance := 0.75
export var run_distance := 1500.0

func _decide_on_next_state() -> State:
	var distance_to_target = owner.target.get_distance()
	if distance_to_target <= attack_distance or owner.is_on_wall():
		if randf() <= attack_chance:
			return get_state("ChargeSequence")
		else:
			return get_state("JumpBackSequence")
	elif distance_to_target >= run_distance:
		return get_state("RunSequence")
	else:
		return get_state("WalkSequence")

extends StateMachine

export var attack_distance := 900.0
export var attack_chance := 0.9
export var run_distance := 1500.0
export var fakeout_chance := 0.3

func _decide_on_next_state() -> State:
	var distance_to_target = owner.target.get_distance()
	if distance_to_target <= attack_distance:
		if randf() <= attack_chance:
			if randf() <= fakeout_chance:
				return get_state("FakeoutSequence")
			return get_state("ChargeSequence")
		return get_state("JumpBackSequence")
	elif distance_to_target >= run_distance:
		return get_state("RunSequence")
	else:
		return get_state("WalkSequence")

extends StateMachine

signal phase_change_started(phase)
signal phase_change_completed(phase)

enum Phases { PHASE_1, PHASE_2, PHASE_3 }
var phase
var in_phase_change := false


func _decide_on_next_state() -> State:
	if owner.get_stats().get_health_percent() > 0.0:
		if owner.get_stats().get_health_percent() >= 0.75:
			if not phase == Phases.PHASE_1:
				change_phase(Phases.PHASE_1)
				return get_state("Sequence1Opener")
		elif owner.get_stats().get_health_percent() >= 0.33:
			if not phase == Phases.PHASE_2:
				change_phase(Phases.PHASE_2)
				return get_state("Sequence2Opener")
		else:
			if not phase == Phases.PHASE_3:
				change_phase(Phases.PHASE_3)
				return get_state("Sequence3Opener")
		
		if in_phase_change:
			in_phase_change = false
			emit_signal("phase_change_completed", phase)
		
		return get_state("Sequence")
	else:
		return get_state("Die")



func change_phase(new_phase : int) -> void:
	phase = new_phase
	in_phase_change = true
	emit_signal("phase_change_started", new_phase)

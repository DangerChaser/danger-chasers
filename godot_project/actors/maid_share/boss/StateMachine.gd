extends StateMachine

signal phase_change_started(phase)
signal phase_change_completed(phase)
signal phase_started
signal phase_change_completed_no_phase

enum Phases { PHASE_1 = 1, PHASE_2 = 2, PHASE_3 = 3 }
var phase
var in_phase_change := false
var SPAWN_TURRET_DISTANCE = 800

func _decide_on_next_state() -> State:
	if owner.stats.character_stats.get_health_percent() <= 0.0:
		return get_state("Die")
	
	if not phase:
		change_phase(Phases.PHASE_1)
		return get_state("Sequence1Opener")
	
	if in_phase_change:
		in_phase_change = false
		emit_signal("phase_change_completed", phase)
		emit_signal("phase_change_completed_no_phase")
	
	var target = owner.target.get_target()
	if target:
		if owner.global_position.distance_to(target.global_position) >= SPAWN_TURRET_DISTANCE:
			return get_state("SpawnTurretSequence")
	
	if owner.stats.character_stats.get_health_percent() >= 0.75:
		return get_state("Sequence1")
	elif owner.stats.character_stats.get_health_percent() >= 0.4:
		if not phase == Phases.PHASE_2:
			change_phase(Phases.PHASE_2)
			return get_state("Sequence2Opener")
		return get_state("Sequence2")
	else:
		if not phase == Phases.PHASE_3:
			change_phase(Phases.PHASE_3)
			return get_state("Sequence3Opener")
		return get_state("Sequence3")


func change_phase(new_phase : int) -> void:
	phase = new_phase
	in_phase_change = true
	emit_signal("phase_change_started", new_phase)
	emit_signal("phase_started")
	owner.kill_spawned_actors()

extends StateMachine

var has_opened : int = 0


func _decide_on_next_state() -> State:
	var health_percent = owner.stats.get_health_percent()
	
	match has_opened:
		0:
			if health_percent <= 0.5:
				has_opened += 1
				return get_state("SpawnSawbladeTurret")
	
	if health_percent >= 0.75:
		return get_state("Sequence1")
	elif health_percent >= 0.33:
		return get_state("Sequence1")
	else:
		return get_state("Sequence1")

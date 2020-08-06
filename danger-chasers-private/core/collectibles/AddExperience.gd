extends Node2D

export(int) var experience := 1

func apply(actor : Actor) -> void:
	var total_experience = actor.stats.experience + experience
	actor.stats.experience = total_experience
	var new_character_stats = actor.stats.growth_stats.create_stats(total_experience)
	actor.call_deferred("set_stats", new_character_stats)
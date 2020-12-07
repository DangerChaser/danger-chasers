extends Bar
class_name HealthBar

func initialize(actor : Actor):
	actor.stats.connect("stats_changed", self, "stats_changed")
	actor.stats.character_stats.connect("health_changed", self, "set_bar")
	set_bar(actor.stats.character_stats.health, actor.stats.character_stats.health, actor.stats.character_stats.max_health)


func stats_changed(new_stats : CharacterStats) -> void:
	new_stats.connect("health_changed", self, "set_bar")
	set_bar(new_stats.health, new_stats.health, new_stats.max_health)

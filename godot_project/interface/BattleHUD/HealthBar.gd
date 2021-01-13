extends Bar
class_name HealthBar

func initialize(actor : Actor):
	actor.stats.connect("health_changed", self, "set_bar")
	set_bar(actor.stats.health, actor.stats.health, actor.stats.max_health)

extends Label

var stats

func update_label(new_stats : CharacterStats) -> void:
	stats = new_stats
	if not stats.is_connected("health_changed", self, "_on_health_changed"):
		stats.connect("health_changed", self, "_on_health_changed")
	if not stats.is_connected("health_depleted", self, "_on_health_depleted"):
		stats.connect("health_depleted", self, "_on_health_depleted")
	if not stats.is_connected("mana_changed", self, "_on_mana_changed"):
		stats.connect("mana_changed", self, "_on_mana_changed")
	if not stats.is_connected("mana_depleted", self, "_on_mana_depleted"):
		stats.connect("mana_depleted", self, "_on_mana_depleted")
	
	text = "Stats\n"
	text += "HP: " + str(stats.health) + "\n"
	text += "Mana: " + str(stats.mana) + "\n"
	text += "Max HP: " + str(stats.max_health) + "\n"
	text += "Max Mana: " + str(stats.max_mana) + "\n"
	text += "Strength: " + str(stats.strength) + "\n"
	text += "Defense: " + str(stats.defense) + "\n"
	text += "Speed: " + str(stats.speed) + "\n"
	text += "Alive: " + str(stats.is_alive) + "\n"
	text += "Level: " + str(stats.level) + "\n"


func _on_health_changed(new_health, old_health, max_health):
	update_label(stats)
func _on_health_depleted():
	update_label(stats)
func _on_mana_changed(new_health, old_health, max_health):
	update_label(stats)
func _on_mana_depleted(new_health, old_health, max_health):
	update_label(stats)

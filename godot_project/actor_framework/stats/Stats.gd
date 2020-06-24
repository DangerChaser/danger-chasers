"""
Node for Actor. Holds an actual copy of the actor's current stats
"""
extends Node

signal stats_changed(new_stats)

export var growth_stats : Resource
export var character_stats : Resource
export(int) var experience := 0


func _ready():
	if growth_stats:
		set_experience(experience)
	else:
		assert (character_stats)


func initialize():
	character_stats = character_stats.duplicate()
	character_stats.reset()
	change_stats(character_stats)


func set_experience(_experience : int) -> void:
	experience = _experience
	change_stats(growth_stats.create_stats(experience))


func change_stats(new_stats : CharacterStats):
	character_stats = new_stats
	emit_signal("stats_changed", character_stats)


func take_damage(damage : int) -> bool:
	character_stats.take_damage(damage)
	return character_stats.health <= 0

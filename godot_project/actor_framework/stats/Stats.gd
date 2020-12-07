"""
Node for Actor. Holds an actual copy of the actor's current stats
"""
extends Node

signal stats_changed(new_stats)

export var character_stats : Resource

onready var buffs := $Buffs
onready var debuffs := $Debuffs
onready var miscellaneous_effects := $Miscellaneous


func _ready():
	character_stats = character_stats.duplicate()
	character_stats.reset()
	change_stats(character_stats)


func change_stats(new_stats : CharacterStats):
	character_stats = new_stats
	emit_signal("stats_changed", character_stats)


func take_damage(damage : int) -> bool:
	character_stats.take_damage(damage)
	return character_stats.health <= 0

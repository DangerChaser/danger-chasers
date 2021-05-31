"""
Node for Actor. Holds an actual copy of the actor's current stats
"""
extends Node

signal health_changed(new_health, old_health, max_health)
signal health_depleted()
signal mana_changed(new_mana, old_mana, max_mana)
signal mana_depleted()
signal stats_changed(new_stats)

export var max_health : int = 1
export var max_mana : int = 0

onready var buffs := $Buffs
onready var debuffs := $Debuffs
onready var miscellaneous_effects := $MiscellaneousEffects
onready var health_vials := $HealthVials
onready var resources : Dictionary = $Resources.dictionary


var modifiers = {}
var health : int
var mana : int
var level : int


func _ready():
	reset()

func reset():
	var old_health = health
	health = self.max_health
	mana = self.max_mana
	emit_signal("health_changed", health, old_health, max_health)

func take_damage(damage : int):
	var old_health = health
	health = max(0, health - damage)
	health_vials.start()
	emit_signal("health_changed", health, old_health, max_health)
	if health == 0:
		emit_signal("health_depleted")
	return health == 0

func heal(amount : int):
	var old_health = health
	health = min(health + amount, max_health)
	emit_signal("health_changed", health, old_health, max_health)


func reduce_mana(amount : int):
	var old_mana = mana
	mana = max(0, mana - amount)
	emit_signal("mana_changed", mana, old_mana, max_mana)
	if mana == 0:
		emit_signal("mana_depleted")


func restore_mana(amount : int):
	var old_mana = mana
	mana = min(mana + amount, max_mana)
	emit_signal("mana_changed", mana, old_mana, max_mana)

func is_alive() -> bool:
	return health >= 0


func get_health_percent() -> float:
	return float(health) / max_health


func add_modifier(id : int, modifier):
	modifiers[id] = modifier

func remove_modifier(id : int):
	modifiers.erase(id)


func _on_HealthVials_vial_finished():
	if health < max_health:
		health_vials.start()

# Combo Effect
extends AttackAdditionalEffect

export(float) var new_damage : float = 100
export(NodePath) var damage_source_node

onready var damage_source : DamageSource = get_node(damage_source_node)
onready var original_damage : float = damage_source.damage


func enter(args := {}) -> void:
	.enter(args)
	damage_source.damage = new_damage


func exit() -> void:
	.exit()
	damage_source.damage = original_damage

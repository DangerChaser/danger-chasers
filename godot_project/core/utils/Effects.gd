extends Node2D

func get_effect(effect_name : String, args := {}) -> Effect:
	for group in get_children():
		if group.has_node(effect_name):
			var new_effect = group.get_node(effect_name).duplicate()
			new_effect.initialize(args)
			return new_effect
	return null
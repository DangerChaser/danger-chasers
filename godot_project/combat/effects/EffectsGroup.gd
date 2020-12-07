extends Node2D

func has(effect_name) -> bool:
	return has_node(effect_name)


func add(effect : Effect) -> void:
	if has(effect.name):
		effect.name = "QueuedToFree"
		effect.queue_free()
	
	add_child(effect)

extends Node2D

func has(effect_name) -> bool:
	return has_node(effect_name)


func add(effect : Effect) -> void:
	if has(effect.name):
		var old_effect = get_node(effect.name)
		old_effect.name = "QueuedToFree"
		old_effect.queue_free()
	
	add_child(effect)

func remove(effect_name : String) -> void:
	if has(effect_name):
		var old_effect = get_node(effect_name)
		old_effect.name = "QueuedToFree"
		old_effect.queue_free()

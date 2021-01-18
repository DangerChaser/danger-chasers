extends Node2D

func spawn_actors(index : int, percent : float, parent=null) -> Array:
	if get_child_count() == 0:
		return []
	var actors = []
	var group = get_child(index)
	
	assert (percent <= 1.0 and percent > 0.0)
	
	for child in group.get_children():
		assert (child is ActorSpawner)
	
	var used_indeces = []
	var current_percent = 0.0
	while current_percent < percent - 0.001:
		var num_indeces = group.get_child_count()
		var new_index = randi() % num_indeces
		if used_indeces.size() < num_indeces and new_index in used_indeces:
			continue
		used_indeces.push_back(new_index)
		var spawner = group.get_child(new_index)
		var actor = spawner.spawn(parent)
		actors.push_back(actor)
		current_percent += float(1) / num_indeces
	
	return actors

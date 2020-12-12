extends Node

enum Layers { OBSTACLES=0, ACTORS=1, DAMAGE_SOURCES=2, ACTIVATION_TRIGGERS=3, ACTIVATION_SCANNERS=4, PLAYER_STOPPERS=5, DROP_THROUGH=6, PASSABLE_ACTORS=7, ENEMY_STOPPERS=8, WALL_RUN=10 }


func get_all_subchildren(root) -> Array:
	var subchildren := []
	for child in root.get_children():
		subchildren.append(child)
		if child.get_child_count() > 0:
			subchildren += get_all_subchildren(child)
	return subchildren


func set_all_children_owner(parent) -> void:
	for child in parent.get_children():
		child.owner = parent.owner
		if child.get_child_count() > 0:
			set_all_children_owner(child)


func tile2unit(tiles : float) -> float:
	return tiles * GameManager.TILE_SIZE.x

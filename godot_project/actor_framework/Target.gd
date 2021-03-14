extends Position2D

signal target_acquired(new_target)
signal unlocked

export var max_distance := -1.0 # Set negative number to lock on regardless of distance

var target


func lock_on(new_target=null) -> void:
	if new_target:
		change_target(new_target)
		emit_signal("target_acquired", get_target())
		return
	
	var closest_enemy
	if owner.is_in_group("players"):
#		closest_enemy = _find_closest_enemy("team_2")
		closest_enemy = _find_closest_enemy("enemies")
	else:
		closest_enemy = _find_closest_enemy("players")
	
	if closest_enemy:
		change_target(closest_enemy)
		emit_signal("target_acquired", get_target())
	else:
		unlock()


func _find_closest_enemy(target_group : String) -> Actor:
	var closest_target = null
	if get_target():
		closest_target = target
	
	for target_position in get_tree().get_nodes_in_group("target_positions"):
		if not target_position.get_parent().get_parent().is_in_group(target_group):
			continue
		
		if closest_target == null:
			closest_target = target_position
		
		var distance_to_new_target = owner.global_position.distance_to(target_position.global_position)
		var distance_to_current_target = owner.global_position.distance_to(closest_target.global_position)
		if distance_to_new_target < distance_to_current_target:
			closest_target = target_position
		
		distance_to_current_target = owner.global_position.distance_to(closest_target.global_position)
		if max_distance >= 0.0 and distance_to_current_target > max_distance:
			closest_target = null
	
	return closest_target


func change_target(new_target) -> void:
	if get_target() and target.owner.is_connected("health_depleted", self, "target_died"):
		target.owner.disconnect("health_depleted", self, "target_died")
	
	if not new_target:
		return
	
	if new_target is Actor:
		new_target = new_target.target_positions.get_child(0)
	
	target = new_target
	if not target.owner.is_connected("health_depleted", self, "target_died"):
		target.owner.connect("health_depleted", self, "target_died")
	global_position = target.global_position


func target_died(old_target):
	target = null


func unlock():
	target = null
	emit_signal("unlocked")


func get_target():
	if target and is_instance_valid(target):
		return target


func get_distance() -> float:
	var target = get_target()
	return owner.global_position.distance_to(target.global_position) if target else 0.0


func get_rotation_to() -> float: # in radians
	var target = get_target()
	return (target.global_position - owner.global_position).angle()

extends Position2D

signal target_acquired(new_target)
signal unlocked

export(float) var max_distance := -1.0 # Set negative number to lock on regardless of distance

var target
var target_wr # Checks if target was freed


func initialize() -> void:
	target = null
	target_wr = null
	lock_on()


func _physics_process(delta : float) -> void:
	if target and target_wr.get_ref():
		if not target_wr.get_ref():
			target = null
			target_wr = null
			if owner.is_in_group("team_2") or owner.is_in_group("team_3"): # Reserved for enemies
				lock_on()
		global_position = target.global_position


func lock_on(new_target=null) -> void:
	if new_target:
		change_target(new_target)
		emit_signal("target_acquired", get_target())
		return
	
	var closest_enemy
	if owner.is_in_group("team_2") or owner.is_in_group("team_3"): # Reserved for enemies
		closest_enemy = find_closest_enemy("players")
	else:
		closest_enemy = find_closest_enemy("team_2")
	
	if closest_enemy:
		change_target(closest_enemy)
		emit_signal("target_acquired", get_target())
	else:
		unlock()


func find_closest_enemy(target_group : String) -> Actor:
	var closest_enemy = null
	if get_target():
		closest_enemy = target
	for enemy in get_tree().get_nodes_in_group(target_group):
		if closest_enemy == null:
			closest_enemy = enemy
		var distance_to_enemy = owner.global_position.distance_to(enemy.global_position)
		var distance_to_current_target = owner.global_position.distance_to(closest_enemy.global_position)
		if distance_to_enemy < distance_to_current_target:
			closest_enemy = enemy
		distance_to_current_target = owner.global_position.distance_to(closest_enemy.global_position)
		if max_distance >= 0.0 and distance_to_current_target > max_distance:
			closest_enemy = null
	return closest_enemy


func change_target(new_target) -> void:
	if get_target() and target.is_connected("health_depleted", self, "target_died"):
		target.disconnect("health_depleted", self, "target_died")
	
	if not new_target:
		return
	
	target = new_target
	target_wr = weakref(target)
	if not target.is_connected("health_depleted", self, "target_died"):
		target.connect("health_depleted", self, "target_died")
	global_position = target.global_position


func target_died(old_target):
	target = null
	target_wr = null


func unlock():
	target = null
	target_wr = null
	emit_signal("unlocked")


func get_target():
	if target and target_wr.get_ref():
		return target


func get_target_wr() -> WeakRef:
	return target_wr.get_ref()

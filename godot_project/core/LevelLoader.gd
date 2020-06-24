extends Node

class_name LevelLoader
signal loaded(level)

export(PackedScene) var player_scene : PackedScene

var player

var level : Level


func change_level(target_level : PackedScene, target_spawn_point : int, transition_in_animation:String, transition_in_duration) -> void:
	if transition_in_animation:
		yield(Transition.transition_in(transition_in_animation, transition_in_duration), "transition_in_finished")
	
	GameManager.initial_spawn_point = target_spawn_point
	
	if player:
		GameManager.players = []
		if player.get_parent():
			player.get_parent().remove_child(player)
	
	if level:
		level.queue_free()
	
	yield(get_tree().create_timer(0.01), "timeout") # Prevents soft lock
	_create_new_level(target_level, target_spawn_point)


func _create_new_level(target_level : PackedScene, target_spawn_point : int):
	level = target_level.instance()
	assert (level is Level)
	GameManager.current_loaded_level = target_level
	add_child(level)
	
	var spawn_point = level.player_spawn_points.get_child(target_spawn_point)
	level.connect("initialized", self, "level_initialized", [target_spawn_point, spawn_point.transition_out_animation, spawn_point.transition_out_duration])
	level.initialize()


func level_initialized(target_spawn_point : int, transition_out_animation : String, transition_out_duration) -> void:
	GameManager.players = []
	spawn_player(target_spawn_point)
	emit_signal("loaded", level)
	yield(Transition.transition_out(transition_out_animation, transition_out_duration), "transition_out_finished")


func spawn_player(target_spawn_point : int):
	if target_spawn_point >= level.player_spawn_points.get_child_count():
		print(str(target_spawn_point) + " is more than the number of spawn points in " + level.name +".")
		print("    Defaulted to spawn point 0.")
		target_spawn_point = 0
	var spawn = level.player_spawn_points.get_child(target_spawn_point)
	spawn.spawn()
	
	if level.player_scene:
		player = level.player_scene.instance()
	else:
		player = player_scene.instance()
	
	player.reset(spawn.global_position)
	GameManager.players.append(player)
	level.y_sort.add_child(player)
	player.call_deferred("initialize", "team_1")
	GameManager.current_camera.get_parent().global_position = spawn.global_position
	yield(get_tree().create_timer(0.01), "timeout")
	GameManager.current_camera.reset_smoothing()

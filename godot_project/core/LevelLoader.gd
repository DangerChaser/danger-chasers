extends Node

class_name LevelLoader
signal loaded(level)

var level : Level


func change_level(target_level : PackedScene, target_spawn_point : int, transition_in_animation:String, transition_in_duration) -> void:
	if transition_in_animation:
		yield(Transition.transition_in(transition_in_animation, transition_in_duration), "transition_in_finished")
	
	GameManager.initial_spawn_point = target_spawn_point
	
	if level:
		level.queue_free()
	
	yield(get_tree().create_timer(0.01), "timeout") # Prevents soft lock
	_create_new_level(target_level, target_spawn_point)


func _create_new_level(target_level : PackedScene, target_spawn_point : int):
	level = target_level.instance()
	assert (level is Level)
	GameManager.current_loaded_level = target_level
	add_child(level)
	
	PlayerManager.player = null
	level.spawn_player(target_spawn_point)
	
	var spawn_point = level.player_spawn_points.get_child(target_spawn_point)
	level.connect("initialized", self, "level_initialized", [spawn_point.transition_out_animation, spawn_point.transition_out_duration])
	level.initialize()


func level_initialized(transition_out_animation : String, transition_out_duration) -> void:
	emit_signal("loaded", level)
	yield(Transition.transition_out(transition_out_animation, transition_out_duration), "transition_out_finished")

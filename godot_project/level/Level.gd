extends Node2D

class_name Level

signal initialized
signal level_change_requested(level)

onready var player_spawn_points : = $PlayerSpawnPoints
onready var camera_limits := $CameraLimits
onready var arenas := $Arenas
onready var y_sort := $YSort

export(Color) var skybox_color : Color = Color(0.5, 0.5, 0.5, 1)
export(PackedScene) var player_scene : PackedScene

func request_change(level_path:String, target_spawn_point:int, transition_in_animation:String, transition_in_duration:float) -> void:
	emit_signal("level_change_requested", load(level_path), target_spawn_point, transition_in_animation, transition_in_duration)


func initialize() -> void:
#	for actor in get_tree().get_nodes_in_group("actors"):
#		actor.initialize("team_0") # Call before any other actor initializations
	
	GameManager.level = self
	
	for door in get_doors():
		door.connect("player_entered", self, "request_change")
	
	if has_node("LevelHUD/LevelIntro"):
		$LevelHUD/LevelIntro.connect("finished", self, "emit_signal", ["initialized"])
		$LevelHUD/LevelIntro.start()
	else:
		emit_signal("initialized")
	
	for arena in arenas.get_children():
		arena.initialize($YSort)


func get_doors() -> Array:
	var doors = []
	for door in get_tree().get_nodes_in_group("doors"):
		assert(door is LevelTransition)
		if not is_a_parent_of(door):
			continue
		doors.push_back(door)
	return doors

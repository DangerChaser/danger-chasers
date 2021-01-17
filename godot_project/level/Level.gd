extends Node2D

class_name Level

signal initialized
signal level_change_requested(level)

onready var player_spawn_points : = $PlayerSpawnPoints
onready var arenas := $Arenas
onready var y_sort := $YSort

export var level_name_key : String
export var act := 1
export var skybox_color : Color = Color(0.5, 0.5, 0.5, 1)
export var player_scene : PackedScene


func request_change(level_path:String, target_spawn_point:int, transition_in_animation:String, transition_in_duration:float) -> void:
	emit_signal("level_change_requested", load(level_path), target_spawn_point, transition_in_animation, transition_in_duration)


func initialize() -> void:
	GameManager.level = self
	for door in get_tree().get_nodes_in_group("doors"):
		door.connect("player_entered", self, "request_change")
	for arena in get_tree().get_nodes_in_group("arenas"):
		arena.initialize($YSort)
	
	emit_signal("initialized")


func spawn_player(target_spawn_point : int):
	if target_spawn_point >= player_spawn_points.get_child_count():
		print(str(target_spawn_point) + " is more than the number of spawn points in " + name +".")
		print("    Defaulted to spawn point 0.")
		target_spawn_point = 0
	var spawn = player_spawn_points.get_child(target_spawn_point)
	var player = player_scene.instance()
	player.initialize_on_ready = false
	y_sort.add_child(player)
	spawn.spawn(player)
	player.call_deferred("initialize", "team_1")
	PlayerManager.player = player

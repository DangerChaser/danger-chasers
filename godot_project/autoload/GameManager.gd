extends Node

var level
var current_camera
var current_loaded_level : PackedScene
var initial_spawn_point : int

var global_cooldown := 0.5

var game
const TILE_SIZE : Vector2 = Vector2(64, 64)

var DEBUG_MODE = true




func _ready() -> void:
#	randomize(
	pass


func clear():
	level = null
	game = null

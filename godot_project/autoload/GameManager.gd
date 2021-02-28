extends Node

var level
var current_camera
var current_loaded_level : PackedScene
var initial_spawn_point : int

var global_cooldown := 0.5

var game
const TILE_SIZE : Vector2 = Vector2(32, 32)

var DEBUG_MODE = true

const USER_DIR : String = "user://"
const SAVE_DIR : String = USER_DIR + "saves/"
var save_file : int = 1
var save_folder : String = SAVE_DIR + str(save_file) + "/"


func _ready() -> void:
#	randomize()
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)


func clear():
	level = null
	game = null

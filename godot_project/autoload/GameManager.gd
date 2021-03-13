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
var save_file_index : int = 1
var save_folder : String = SAVE_DIR + str(save_file_index) + "/"
var save_file : String = save_folder + "save.dat"
var save_data : Dictionary


func _ready() -> void:
#	randomize()
	var dir = Directory.new()
	if not dir.dir_exists(SAVE_DIR):
		dir.make_dir_recursive(SAVE_DIR)
	set_save_file(1)

func clear():
	level = null
	game = null


func set_save_file(index := 1) -> void:
	save_file_index = index
	save_folder = SAVE_DIR + str(save_file_index) + "/"
	save_file = save_folder + "save.dat"
	
	var dir = Directory.new()
	if not dir.dir_exists(save_folder):
		dir.make_dir_recursive(save_folder)


func save(access_key, value) -> void:
	var file = File.new()
	var error = file.open(save_file, File.WRITE)
	if not error == OK:
		print_debug("Error opening " + save_file + ".")
		return
	
	save_data[access_key] = value
	file.store_var(save_data)
	file.close()


func load_data() -> Dictionary:
	var file = File.new()
	if not file.file_exists(save_file):
		print_debug("File " + save_file + " does not exist.")
		return save_data
	
	var error = file.open(save_file, File.READ)
	if not error == OK:
		print_debug("Error opening " + save_file + ".")
		return save_data
		
	save_data = file.get_var()
	file.close()
	return save_data

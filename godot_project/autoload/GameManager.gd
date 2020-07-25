extends Node

var level
var current_camera
var current_loaded_level : PackedScene
var initial_spawn_point : int
var players = []

var num_players : int
var player_animation_players : Array

var global_cooldown := 0.5

var game
const TILE_SIZE : Vector2 = Vector2(64, 64)

enum Layers { OBSTACLES=0, ACTORS=1, DAMAGE_SOURCES=2, ACTIVATION_TRIGGERS=3, ACTIVATION_SCANNERS=4 }




func _ready() -> void:
	#OS.window_fullscreen = true
	randomize() # Big brain time, only needs to be called once, EVER


func get_player():
	return players[0]


func clear():
	players = []
	level = null
	game = null

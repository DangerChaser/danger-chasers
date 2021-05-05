"""
Responsible for transitions between the main game screens:
combat, game over, and the map
"""
extends Node

onready var level_loader : LevelLoader = $LevelLoader
onready var music_player : AudioStreamPlayer = $MusicPlayer
onready var Skybox : ColorRect = $Background/Skybox
onready var camera := $Camera2D
onready var pause_menu := $Interface/PauseMenu

export(PackedScene) var LEVEL_START : PackedScene # Should only be used if testing directly from editor



func _ready() -> void:
	GameManager.game = self
	
	pause_menu.hide_menus()
	GameManager.current_camera = camera
	if not GameManager.current_loaded_level:
		GameManager.current_loaded_level = LEVEL_START
	print_debug("Load level from Game.gd")
	level_loader.change_level(GameManager.current_loaded_level, 0, "left_to_right", 0.1)


func level_loaded(level : Level) -> void:
	Skybox.color = level.skybox_color
	
	yield(get_tree().create_timer(0.1), "timeout") # Prevents bug where level will immediately transition if player ended up inside a level transition from the previous level
	level.connect("level_change_requested", level_loader, "change_level")

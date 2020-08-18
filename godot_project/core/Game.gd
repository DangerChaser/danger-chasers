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
	Dialogue.camera = camera
	if not GameManager.current_loaded_level:
		GameManager.current_loaded_level = LEVEL_START
	level_loader.change_level(GameManager.current_loaded_level, 0, "left_to_right", 0.1)


func level_loaded(level : Level) -> void:
	Skybox.color = level.skybox_color
	
	connect_player(PlayerManager.player)
	
	yield(get_tree().create_timer(0.1), "timeout") # Prevents bug where level will immediately transition if player ended up inside a level transition from the previous level
	level.connect("level_change_requested", level_loader, "change_level")


func connect_player(player) -> void:
	if not player.is_connected("died", self, "_on_player_died"):
		player.connect("died", self, "_on_player_died")


func _on_player_died(player) -> void:
	PlayerManager.player = null
	yield(get_tree().create_timer(1.0), "timeout")
	pause_menu._on_Restart_button_down()

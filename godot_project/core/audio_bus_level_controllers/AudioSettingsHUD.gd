extends Control

signal finished

onready var music_button := $HBoxContainer/Music/Button
onready var sfx_button := $HBoxContainer/Sfx/Button
onready var ambience_button := $HBoxContainer/Ambience/Button
onready var music_level_controller : AudioBusLevelController = $HBoxContainer/Music/MusicLevelController
onready var sfx_level_controller : AudioBusLevelController = $HBoxContainer/Sfx/SoundLevelController
onready var ambience_level_controller : AudioBusLevelController = $HBoxContainer/Ambience/AmbienceLevelController

onready var last_button = music_button


func _ready() -> void:
	visible = false


func enable() -> void:
	visible = true
	last_button.grab_focus()
	PlayerManager.disable_input()


func disable() -> void:
	visible = false
	PlayerManager.enable_input()
	music_level_controller.disable()
	sfx_level_controller.disable()
	ambience_level_controller.disable()


func _on_MusicLevelController_enabled():
	last_button = music_button
	sfx_level_controller.disable()
	ambience_level_controller.disable()


func _on_SoundLevelController_enabled():
	last_button = sfx_button
	music_level_controller.disable()
	ambience_level_controller.disable()


func _on_AmbienceLevelController_enabled():
	last_button = ambience_button
	music_level_controller.disable()
	sfx_level_controller.disable()


func _on_BackButton_button_down():
	disable()
	emit_signal("finished")

extends Node2D

onready var main_menu := $CanvasLayer/Control/Main
onready var new_game_menu := $CanvasLayer/Control/NewGame
onready var continue_menu := $CanvasLayer/Control/Continue
onready var settings_menu := $CanvasLayer/Control/SettingsMenu
onready var press_any_button_menu := $CanvasLayer/Control/PressAnyButton

func _ready():
	main_menu.visible = false
	new_game_menu.visible = false
	continue_menu.visible = false
	settings_menu.visible = false
	press_any_button_menu.start()


func _on_PressAnyButton_finished():
	press_any_button_menu.transition_out()
	main_menu.start()


func _on_Main_new_game_button_pressed():
	main_menu.transition_out()
	new_game_menu.start()


func _on_Main_continue_button_pressed():
	main_menu.transition_out()
	continue_menu.start()


func _on_Main_settings_button_pressed():
	main_menu.transition_out()
	settings_menu.start()


func _on_NewGame_no_selected():
	new_game_menu.transition_out()
	main_menu.transition_in()


func _on_Continue_back_selected():
	continue_menu.transition_out()
	main_menu.transition_in()


func _on_SettingsMenu_back_selected():
	settings_menu.transition_out()
	main_menu.transition_in()

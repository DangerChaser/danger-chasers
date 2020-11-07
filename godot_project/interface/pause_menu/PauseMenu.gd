extends CanvasLayer

export(String) var game_path : String
export(String) var main_menu_path : String
export(String) var restart_transition_in_animation : String
export(float) var restart_transition_in_duration := 0.5
export(String) var quit_transition_in_animation : String
export(float) var quit_transition_in_duration := 0.5

onready var pause_menu : Control = $Pause
onready var settings_menu : Control = $Settings
onready var input_menu : InputMenu = $InputMenu
onready var audio_menu := $AudioSettingsHUD
onready var graphics_menu := $GraphicsMenu
onready var menus = [pause_menu, settings_menu, input_menu, audio_menu, graphics_menu]
enum Menus { PAUSE, SETTINGS, INPUT, AUDIO, GRAPHICS, UNPAUSED }

var current_menu


func _ready() -> void:
	hide_menus()


func pause() -> void:
	get_tree().paused = true
	$Background.visible = true
	$PauseSfx.play()
	
	PlayerManager.disable_input()
	
	if current_menu == Menus.PAUSE:
		unpause()
	elif current_menu == Menus.SETTINGS:
		change_menu(Menus.PAUSE)
	elif current_menu == Menus.INPUT:
		change_menu(Menus.SETTINGS)
		input_menu.disable()
	elif current_menu == Menus.AUDIO:
		change_menu(Menus.SETTINGS)
		audio_menu.disable()
	elif current_menu == Menus.GRAPHICS:
		change_menu(Menus.SETTINGS)
		graphics_menu.disable()
	else:
		change_menu(Menus.PAUSE)


func unpause() -> void:
	$Background.visible = false
	PlayerManager.enable_input()
	change_menu(Menus.UNPAUSED)
	get_tree().paused = false


func change_menu(new_menu) -> void:
	current_menu = new_menu
	
	hide_menus()
	if current_menu == Menus.PAUSE:
		pause_menu.visible = true
		pause_menu.get_node("Buttons").get_child(0).grab_focus()
	elif current_menu == Menus.SETTINGS:
		settings_menu.visible = true
		settings_menu.get_node("Buttons").get_child(0).grab_focus()
	elif current_menu == Menus.INPUT:
		input_menu.enable()
	elif current_menu == Menus.AUDIO:
		audio_menu.enable()
	elif current_menu == Menus.GRAPHICS:
		graphics_menu.enable()


func _input(event : InputEvent) -> void:
	if event.is_action_pressed("pause"):
		if not get_tree().paused:
			pause()
			return


func hide_menus() -> void:
	for menu in menus:
		menu.visible = false


func _on_Resume_pressed():
	unpause()


func _on_Restart_pressed():
	yield(Transition.transition_in(restart_transition_in_animation, restart_transition_in_duration), "transition_in_finished")
	GameManager.game.level_loader.change_level(GameManager.current_loaded_level, GameManager.initial_spawn_point, "left_to_right", 0.5)
	unpause()


func _on_Quit_pressed():
	yield(Transition.transition_in(quit_transition_in_animation, quit_transition_in_duration), "transition_in_finished")
	GameManager.clear()
	GameManager.current_loaded_level = load(main_menu_path)
	get_tree().change_scene(game_path)
	unpause()


func _on_Settings_pressed():
	change_menu(Menus.SETTINGS)


func _on_Controls_pressed():
	change_menu(Menus.INPUT)


func _on_SettingsBack_pressed():
	change_menu(Menus.PAUSE)


func _on_InputMenu_finished():
	change_menu(Menus.SETTINGS)


func _on_Audio_pressed():
	change_menu(Menus.AUDIO)


func _on_AudioSettingsHUD_finished():
	change_menu(Menus.SETTINGS)


func _on_Graphics_pressed():
	change_menu(Menus.GRAPHICS)


func _on_GraphicsMenu_finished():
	change_menu(Menus.SETTINGS)

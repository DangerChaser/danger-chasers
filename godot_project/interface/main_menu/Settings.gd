extends Control

signal back_selected

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var label : KeyLabel = $SettingsLabel
onready var last_button : Button = $Buttons/BoxContainer/Audio

var game_path := "res://core/Game.tscn"


func start() -> void:
	animation_player.play("start")
	visible = true
	label.visible = true
	$Buttons.visible = true
	$AudioSettingsHUD.visible = false
	$InputMenu.visible = false
	$GraphicsMenu.visible = false


func submenu_transition_out() -> void:
	label.visible = false
	$Buttons.visible = false
	animation_player.play("submenu_transition_out")


func submenu_transition_in() -> void:
	animation_player.play("submenu_transition_in")
	visible = true
	label.visible = true
	$Buttons.visible = true
	$AudioSettingsHUD.visible = false
	$InputMenu.visible = false
	$GraphicsMenu.visible = false


func transition_out() -> void:
	last_button = $Buttons/BoxContainer/Audio
	label.visible = false
	$Buttons.visible = false
	animation_player.play("transition_out")


func _on_AudioSettingsHUD_finished() -> void:
	submenu_transition_in()


func _on_InputMenu_finished() -> void:
	submenu_transition_in()


func _on_GraphicsMenu_finished() -> void:
	submenu_transition_in()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start" or anim_name == "submenu_transition_in":
		last_button.grab_focus()


func _on_Audio_pressed():
	last_button = $Buttons/BoxContainer/Audio
	submenu_transition_out()
	$AudioSettingsHUD.enable()


func _on_Controls_pressed():
	last_button = $Buttons/BoxContainer/Controls
	submenu_transition_out()
	$InputMenu.enable()


func _on_Graphics_pressed():
	last_button = $Buttons/BoxContainer/Graphics
	submenu_transition_out()
	$GraphicsMenu.enable()


func _on_BackButton_pressed():
	emit_signal("back_selected")

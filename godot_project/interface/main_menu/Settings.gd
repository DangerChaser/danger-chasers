extends Control

signal back_selected

onready var animation_player : AnimationPlayer = $AnimationPlayer

var game_path := "res://core/Game.tscn"


func _on_BackButton_button_down():
	emit_signal("back_selected")


func start():
	animation_player.play("start")
	visible = true
	$AudioSettingsHUD.visible = false
	$InputMenu.visible = false
	yield(get_tree().create_timer(animation_player.current_animation_length), "timeout")
	$Buttons/HBoxContainer/Audio.grab_focus()


func transition_out():
	animation_player.play("transition_out")


func _on_Audio_button_down():
	transition_out()
	$AudioSettingsHUD.enable()


func _on_AudioSettingsHUD_finished():
	start()


func _on_InputMenu_finished():
	start()


func _on_Controls_button_down():
	transition_out()
	$InputMenu.enable()

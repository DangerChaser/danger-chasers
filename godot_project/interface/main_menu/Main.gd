extends Control

signal finished
signal new_game_button_pressed
signal continue_button_pressed
signal settings_button_pressed

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var last_button = $Buttons/BoxContainer/NewGameButton

func start() -> void:
	visible = true
	animation_player.play("start")


func transition_out() -> void:
	animation_player.play("transition_out")


func transition_in() -> void:
	visible = true
	animation_player.play("transition_in")


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start" or anim_name == "transition_in":
		last_button.grab_focus()


func _on_NewGameButton_pressed():
	last_button = $Buttons/BoxContainer/NewGameButton
	emit_signal("new_game_button_pressed")


func _on_ContinueButton_pressed():
	last_button = $Buttons/BoxContainer/ContinueButton
	emit_signal("continue_button_pressed")


func _on_SettingsButton_pressed():
	last_button = $Buttons/BoxContainer/SettingsButton
	emit_signal("settings_button_pressed")


func _on_ExitButton_pressed():
	last_button = $Buttons/BoxContainer/ExitButton
	animation_player.play("exit")
	yield(get_tree().create_timer(animation_player.current_animation_length), "timeout")
	get_tree().quit()

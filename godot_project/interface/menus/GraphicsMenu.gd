extends Control

signal finished

onready var screen_shake_button := $Buttons/ScreenShake/ScreenShakeButton
onready var back_button := $Buttons/BackButton
onready var last_button := screen_shake_button

func _ready() -> void:
	visible = false
	_update_screen_shake()


func enable() -> void:
	visible = true
	last_button.grab_focus()
	PlayerManager.disable_input()


func disable() -> void:
	visible = false
	PlayerManager.enable_input()


func _update_screen_shake():
	if Settings.screen_shake_enabled:
		screen_shake_button.set_key("ON")
	else:
		screen_shake_button.set_key("OFF")

func _on_ScreenShakeButton_button_down():
	last_button = screen_shake_button
	Settings.screen_shake_enabled = not Settings.screen_shake_enabled
	_update_screen_shake()


func _on_BackButton_button_down():
	last_button = back_button
	disable()
	emit_signal("finished")

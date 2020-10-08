extends Control

signal finished

onready var screen_shake_button := $Buttons/ScreenShake/ScreenShakeButton
onready var frame_freeze_button := $Buttons/FrameFreeze/FrameFreezeButton
onready var window_mode_button := $Buttons/WindowMode/WindowModeButton
onready var back_button := $Buttons/BackButton
onready var last_button := screen_shake_button

func _ready() -> void:
	visible = false
	_update_screen_shake()
	_update_frame_freeze()
	_update_window_mode()


func enable() -> void:
	visible = true
	last_button.grab_focus()
	PlayerManager.disable_input()


func disable() -> void:
	visible = false
	PlayerManager.enable_input()


func _update_screen_shake():
	match Settings.screen_shake:
		Settings.ScreenShakeIntensity.DISABLED:
			screen_shake_button.set_key("DISABLED")
		Settings.ScreenShakeIntensity.LOW:
			screen_shake_button.set_key("LOW")
		Settings.ScreenShakeIntensity.NORMAL:
			screen_shake_button.set_key("NORMAL")
		Settings.ScreenShakeIntensity.HIGH:
			screen_shake_button.set_key("HIGH")
		Settings.ScreenShakeIntensity.EXTREME:
			screen_shake_button.set_key("EXTREME")
		Settings.ScreenShakeIntensity.VOMIT:
			screen_shake_button.set_key("VOMIT")


func _update_frame_freeze():
	if Settings.frame_freeze_enabled:
		frame_freeze_button.set_key("ON")
	else:
		frame_freeze_button.set_key("OFF")


func _update_window_mode():
	if Settings.window_mode == Settings.WindowModes.WINDOWED:
		window_mode_button.set_key("WINDOWED")
	elif Settings.window_mode == Settings.WindowModes.FULL_SCREEN:
		window_mode_button.set_key("FULL_SCREEN")


func _on_ScreenShakeButton_pressed():
	last_button = screen_shake_button
	match Settings.screen_shake:
		Settings.ScreenShakeIntensity.DISABLED:
			Settings.screen_shake = Settings.ScreenShakeIntensity.LOW
		Settings.ScreenShakeIntensity.LOW:
			Settings.screen_shake = Settings.ScreenShakeIntensity.NORMAL
		Settings.ScreenShakeIntensity.NORMAL:
			Settings.screen_shake = Settings.ScreenShakeIntensity.HIGH
		Settings.ScreenShakeIntensity.HIGH:
			Settings.screen_shake = Settings.ScreenShakeIntensity.EXTREME
		Settings.ScreenShakeIntensity.EXTREME:
			Settings.screen_shake = Settings.ScreenShakeIntensity.VOMIT
		Settings.ScreenShakeIntensity.VOMIT:
			Settings.screen_shake = Settings.ScreenShakeIntensity.DISABLED
	_update_screen_shake()


func _on_FrameFreezeButton_pressed():
	Settings.frame_freeze_enabled = not Settings.frame_freeze_enabled
	_update_frame_freeze()


func _on_WindowModeButton_pressed():
	if Settings.window_mode == Settings.WindowModes.WINDOWED:
		Settings.window_mode = Settings.WindowModes.FULL_SCREEN
	elif Settings.window_mode == Settings.WindowModes.FULL_SCREEN:
		Settings.window_mode = Settings.WindowModes.WINDOWED
	_update_window_mode()


func _on_BackButton_pressed():
	last_button = back_button
	disable()
	emit_signal("finished")

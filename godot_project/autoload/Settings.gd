extends Node

enum ScreenShakeIntensity { DISABLED, LOW, NORMAL, HIGH, EXTREME, VOMIT }
var screen_shake = ScreenShakeIntensity.NORMAL
var frame_freeze_enabled := true
enum WindowModes { WINDOWED, FULL_SCREEN }
var window_mode = WindowModes.WINDOWED setget set_window_mode


func set_window_mode(value):
	if value == WindowModes.WINDOWED:
		OS.window_fullscreen = false
	elif value == WindowModes.FULL_SCREEN:
		OS.window_fullscreen = true
	window_mode = value

extends Node

func request(delay_milliseconds : int) -> void:
	if not Settings.frame_freeze_enabled:
		return
	OS.delay_msec(delay_milliseconds)

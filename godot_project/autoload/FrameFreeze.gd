extends Node

var enabled : bool = true

func request(delay_milliseconds : int) -> void:
	if not enabled:
		return
	OS.delay_msec(delay_milliseconds)
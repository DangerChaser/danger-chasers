extends Node2D

onready var duration_timer : Timer = $Duration
onready var flash_timer : Timer = $FlashTimer

var flashing := false


func start(duration : float) -> void:
	duration_timer.wait_time = duration
	duration_timer.start()
	flash_timer.start()
	flash()


func _on_Duration_timeout():
	flash_timer.stop()
	unflash()


func _on_FlashTimer_timeout():
	if flashing:
		unflash()
	else:
		flash()

func flash() -> void:
	#To make sprite turn to white
	owner.pivot.modulate = Color(10,10,10,10)
	flashing = true

func unflash() -> void:
	#and to return to normal color
	owner.pivot.modulate = Color(1,1,1,1)
	flashing = false

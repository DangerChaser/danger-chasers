extends WaitState
class_name WaitTime

export var duration := 0.5
export var duration_variation := 0.0

onready var timer : Timer = $Timer


func enter(args := {}) -> void:
	.enter(args)
	timer.start(duration + randf() * duration_variation)


func exit() -> void:
	.exit()
	timer.stop()


func _on_Timer_timeout():
	go_to_next_state()


func pause() -> void:
	.pause()
	timer.paused = true


func unpause() -> void:
	.unpause()
	timer.paused = false

extends WaitState
class_name WaitForTargetDistance


export var duration := 0.5
export var duration_variation := 0.0

onready var timer : Timer = $Timer

export var target_distance := 1000.0
export var transition_animation := ""

var transition_out : bool = false


func _physics_process(delta : float):
	if transition_out:
		return
	
	if owner.global_position.distance_to(owner.target.global_position) < target_distance:
		timer.start(duration + randf() * duration_variation)
		owner.play_animation(transition_animation)
		transition_out = true

func exit() -> void:
	.exit()
	timer.stop()
	transition_out = false

func _on_Timer_timeout():
	go_to_next_state()

func pause() -> void:
	print_debug("a")
	.pause()
	timer.paused = true

func unpause() -> void:
	.unpause()
	timer.paused = false

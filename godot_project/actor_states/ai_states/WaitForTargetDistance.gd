extends WaitState
class_name WaitForTargetDistance


export var duration := 0.5
export var duration_variation := 0.0

onready var timer : Timer = $Timer

export var target_distance := 1000.0
export var transition_animation := ""


func _physics_process(delta : float):
	if owner.global_position.distance_to(owner.target.global_position) < target_distance:
		timer.start(duration + randf() * duration_variation)
		owner.play_animation(transition_animation)
		set_physics_process(false)

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

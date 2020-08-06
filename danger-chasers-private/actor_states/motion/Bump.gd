extends MotionState

export(String) var animation : String = "bump"
export(String) var next_state := ""


func enter(args := {}) -> void:
	.enter(args)
	owner.play_animation(animation)


func anim_finished(animation_name : String) -> void:
	assert (animation_name == animation)
	emit_signal("finished", next_state)

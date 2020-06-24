extends MotionState

export(String) var animation : String = "bump"
export(String) var next_state := ""


func enter(args := {}) -> void:
	.enter(args)
	if owner.animation_player.has_animation(animation):
		owner.animation_player.play(animation)


func anim_finished(animation_name : String) -> void:
	assert (animation_name == animation)
	emit_signal("finished", next_state)

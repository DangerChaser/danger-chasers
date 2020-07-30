extends MotionState

export(String) var animation : String = "spawn"
export(String) var next_state := ""


func enter(args := {}) -> void:
	if args.has("look_direction"):
		update_look_direction(args["look_direction"])
	
	.enter(args)
	owner.play_animation(animation)


func anim_finished(anim_name : String) -> void:
	if anim_name == "SETUP":
		return
	assert (anim_name == animation)
	finished(next_state)

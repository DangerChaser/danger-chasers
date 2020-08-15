extends MotionState

export(String) var animation : String = "prepare"
export(String) var next_state := ""
export(bool) var stagger := false


func enter(args := {}) -> void:
	.enter(args)
	owner.play_animation(animation)


func take_damage(args := {}):
	if stagger:
		finished("Stagger", args)


func anim_finished(anim_name : String) -> void:
	var args = {
		"velocity": steering.velocity, 
		"gravity_speed":gravity.speed,
		"external": {
			"velocity" : external.velocity,
			"target_direction" : external.target_direction,
			"target_speed" : external.target_speed,
			"mass" : external.mass
		}
	}
	owner.target.lock_on()
	if owner.target.get_target():
		var target_position = owner.target.get_target().global_position
		var target_direction = (target_position - owner.global_position).normalized()
		args["target_direction"] = target_direction
	finished(next_state, args)

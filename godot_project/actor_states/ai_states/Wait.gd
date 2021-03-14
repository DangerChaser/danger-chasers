extends MotionState
class_name WaitState

export var animation : String = "prepare"
export var next_state := ""
export var stagger_state := "Stagger"
export var face_target := true

func enter(args := {}) -> void:
	.enter(args)
	
	if args.has("initial_animation"):
		owner.play_animation(args["initial_animation"])
	else:
		owner.play_animation(animation)


func _physics_process(delta):
	move(Vector2())
	if face_target and owner.target.get_target():
		var direction = owner.global_position.direction_to(owner.target.get_target().global_position)
		owner.set_rotation(Vector2(sign(direction.x), 0).angle())


func take_damage(args := {}):
	if stagger_state and owner.state_machine.has_state(stagger_state):
		finished(stagger_state, args)


func go_to_next_state() -> void:
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
	var target = owner.target.get_target()
	if target:
		var target_position = target.global_position
		var target_direction = (target_position - owner.global_position).normalized()
		args["target_direction"] = target_direction
		args["target_position"] = target_position
	finished(next_state, args)


func anim_finished(anim_name : String) -> void:
	owner.play_animation(animation)

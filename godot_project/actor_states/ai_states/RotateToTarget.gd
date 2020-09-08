extends WaitTime

export var lerp_value := 1.0

var target
var target_wr
var internal_rotation

func enter(args := {}) -> void:
	.enter(args)
	if not target or not target_wr.get_ref():
		owner.target.lock_on()
		target = owner.target.get_target()
		target_wr = weakref(target)
		
		if not target or not target_wr.get_ref():
			finished(next_state)
			return
	
	internal_rotation = owner.get_rotation()

func _physics_process(delta):
	if not target or not target_wr.get_ref():
		owner.target.lock_on()
		target = owner.target.get_target()
		target_wr = weakref(target)
	
	var target_direction = (target.global_position - owner.global_position).normalized()
	var target_angle = target_direction.angle()
	
	# Smooth rotation: rotate around completely
	if target_angle - internal_rotation > PI:
		target_angle -= 2 * PI
	elif internal_rotation - target_angle > PI:
		target_angle += 2 * PI
	internal_rotation = lerp(internal_rotation, target_angle, lerp_value)
	
	owner.set_rotation(internal_rotation)

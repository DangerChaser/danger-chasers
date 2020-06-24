extends MovementEffect
class_name BounceEffect

export(PackedScene) var sfx_particle : PackedScene


func _physics_process(delta:float) -> void:
	._physics_process(delta)
	
	if sfx_particle:
		if owner.get_slide_count() > 0:
			var collision = owner.get_slide_collision(owner.get_slide_count() - 1)
			var new_particles = sfx_particle.instance()
			new_particles.start(collision.position, global_rotation, global_scale, owner.get_parent())
	if owner.is_on_floor():
		motion.gravity.speed = -motion.gravity.speed
		var velocity = motion.gravity.speed * motion.gravity.direction
		motion.gravity.velocity = velocity
		owner.move_and_slide(velocity)
	if owner.is_on_wall():
		target_direction.x *= -1
		motion.steering.velocity.x *= -1
	if owner.is_on_ceiling():
		motion.gravity.speed = -motion.gravity.speed
extends AttackAdditionalEffect
class_name SpawnHitParticlesEffect


func enter(args := {}) -> void:
	.enter(args)
	var hit_particles = get_parent().get_parent().get_node("HitParticles")
	hit_particles.spawn(hit_particles.global_position)

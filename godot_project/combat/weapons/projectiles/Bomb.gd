extends Projectile


func destroy() -> SfxParticle:
	.destroy()
	var particles = .destroy()
	if particles.has_node("DamageSource"):
		particles.get_node("DamageSource").friendly_teams = friendly_teams
	return particles


func _on_DamageParticles_spawned(object):
	var particles = object
	if particles.has_node("DamageSource"):
		particles.get_node("DamageSource").friendly_teams = friendly_teams
		particles.start(global_position, \
 					motion.steering.velocity.angle() + PI, \
					global_scale.abs(), \
					get_parent())

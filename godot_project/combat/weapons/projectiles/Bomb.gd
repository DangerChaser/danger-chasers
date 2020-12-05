extends Projectile


func destroy() -> SfxParticle:
	.destroy()
	var particles = .destroy()
	particles.get_node("DamageSource").friendly_teams = friendly_teams
	return particles

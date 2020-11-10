extends Projectile


func destroy() -> void:
	$AnimationPlayer.play("destroy")
	set_physics_process(false)
	var particles = spawn_particles(destroy_particles)
	particles.get_node("DamageSource").friendly_teams = friendly_teams

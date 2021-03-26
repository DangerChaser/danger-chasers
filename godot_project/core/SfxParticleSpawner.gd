extends ObjectSpawner
class_name SfxParticleSpawner


func spawn(parent=null):
	var sfx_particles = .spawn(parent)
	sfx_particles.z_index = z_index
	sfx_particles.z_as_relative = z_as_relative
	sfx_particles.start(Vector2(), global_rotation, global_scale, parent)

extends ObjectSpawner
class_name SfxParticleSpawner


func spawn(parent=null):
	var sfx_particles = .spawn(parent)
	sfx_particles.start(Vector2(), global_rotation, Vector2(), null)

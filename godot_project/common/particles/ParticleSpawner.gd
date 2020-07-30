extends Node2D
class_name ParticleSpawner

export var particles : PackedScene
onready var object_spawner : ObjectSpawner = $ObjectSpawner


func _ready():
	if not object_spawner.object:
		object_spawner.object = particles


func spawn(_global_position : Vector2 = global_position, \
		_global_rotation : float = global_rotation, \
		_global_scale : Vector2 = global_scale, \
		parent := GameManager.level,
		direction := Vector2()):
	if not object_spawner.object:
		object_spawner.object = particles
	var particles = object_spawner.spawn()
	if not particles:
		return
	assert (particles is SfxParticle)
	particles.start(_global_position, _global_rotation, _global_scale, parent, direction)
	return particles


func play():
	spawn()

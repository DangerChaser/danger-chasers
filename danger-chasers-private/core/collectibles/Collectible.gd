extends Node2D

signal collected

export(PackedScene) var sfx_particles : PackedScene

onready var effects := $Effects

func _on_Area2D_area_entered(area):
	var object = area.owner
	for effect in effects.get_children():
		effect.apply(object)
	
	if sfx_particles:
		var sfx_particle = sfx_particles.instance()
		sfx_particle.start(global_position, global_rotation, global_scale, get_parent())
	
	emit_signal("collected")
	queue_free()

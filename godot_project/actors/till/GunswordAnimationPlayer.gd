extends AnimationPlayer

export(NodePath) var grind_sfx
export(NodePath) var grind_particles


func play(name: String = "", custom_blend: float = -1, custom_speed: float = 1.0, from_end: bool = false) -> void:
	var grind_sfx_node = get_node(grind_sfx)
	var grind_particles_node = get_node(grind_particles)
	if current_animation == "run":
		grind_sfx_node.stop()
		grind_particles_node.emitting = false
	if name == "run":
		grind_sfx_node.play()
		grind_particles_node.emitting = true
	.play(name, custom_blend, custom_speed, from_end)

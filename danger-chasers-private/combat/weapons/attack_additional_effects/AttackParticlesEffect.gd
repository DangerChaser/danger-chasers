extends AttackAdditionalEffect
class_name AttackParticlesEffect

export(NodePath) var particles

func _ready() -> void:
	particles = get_node(particles)
	particles.disable_emitting()

func enter(args := {}) -> void:
	particles.enable_emitting()

func exit() -> void:
	particles.disable_emitting()

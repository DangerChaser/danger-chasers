extends AttackAdditionalEffect

export var offset : Vector2

func enter(args := {}) -> void:
	weapon.global_position = owner.target.global_position + offset

extends AttackAdditionalEffect

export var offset : Vector2

var target_position : Vector2

func enter(args := {}) -> void:
	.enter(args)
	target_position = owner.target.global_position + offset
	attack.global_position = target_position


func exit() -> void:
	set_physics_process(true)


func _physics_process(delta):
	attack.global_position = target_position

extends AttackAdditionalEffect

export var offset : Vector2
export var random_offset : Vector2

var target_position : Vector2

func enter(args := {}) -> void:
	.enter(args)
	var rand = Vector2(rand_range(-random_offset.x, random_offset.x), rand_range(-random_offset.y, random_offset.y))
	target_position = owner.target.global_position + offset + rand
	attack.global_position = target_position
	set_physics_process(true)


func exit() -> void:
	.exit()
	set_physics_process(true)


func _physics_process(delta):
	attack.global_position = target_position

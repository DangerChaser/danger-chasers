extends AttackAdditionalEffect

export var unhittable_scene : PackedScene
var current_buff

func enter(args := {}) -> void:
	.enter(args)
	current_buff = unhittable_scene.instance()
	owner.stats.buffs.add(current_buff)

func exit() -> void:
	.exit()
	if is_instance_valid(current_buff):
		current_buff.queue_free()

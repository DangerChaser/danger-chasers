extends AttackAdditionalEffect

var original_layer_bit : bool


func enter(args := {}) -> void:
	.enter(args)
	original_layer_bit = owner.get_collision_layer_bit(Utilities.PASSABLE_ACTOR)
	owner.set_collision_mask_bit(Utilities.PASSABLE_ACTOR, false)
	owner.set_collision_layer_bit(Utilities.PASSABLE_ACTOR, false)


func exit() -> void:
	.exit()
	owner.set_collision_mask_bit(Utilities.PASSABLE_ACTOR, true)
	owner.set_collision_layer_bit(Utilities.PASSABLE_ACTOR, original_layer_bit)

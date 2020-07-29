extends AttackAdditionalEffect



func enter(args := {}) -> void:
	.enter(args)
	owner.set_collision_mask_bit(Utilities.PASSABLE_ACTOR, false)


func exit() -> void:
	.exit()
	owner.set_collision_mask_bit(Utilities.PASSABLE_ACTOR, true)

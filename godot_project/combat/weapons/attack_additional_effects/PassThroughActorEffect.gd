extends AttackAdditionalEffect

var original_mask_bit : bool
var original_layer_bit : bool


func enter(args := {}) -> void:
	.enter(args)
	original_mask_bit = owner.get_collision_mask_bit(Utilities.Layers.PASSABLE_ACTORS)
	original_layer_bit = owner.get_collision_layer_bit(Utilities.Layers.PASSABLE_ACTORS)
	owner.set_collision_mask_bit(Utilities.Layers.PASSABLE_ACTORS, false)
	owner.set_collision_layer_bit(Utilities.Layers.PASSABLE_ACTORS, false)


func exit() -> void:
	.exit()
	owner.set_collision_mask_bit(Utilities.Layers.PASSABLE_ACTORS, original_mask_bit)
	owner.set_collision_layer_bit(Utilities.Layers.PASSABLE_ACTORS, original_layer_bit)

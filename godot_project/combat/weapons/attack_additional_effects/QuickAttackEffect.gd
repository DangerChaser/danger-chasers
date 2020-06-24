extends MovementEffect
class_name QuickAttackEffect

const DROP_THRU_BIT = 6
const PASSABLE_ACTOR = 7

export(String) var horizontal_animation := "quick_attack"
export(String) var up_animation := "jump_up_slash"
export(String) var down_animation := "stomp"


func enter(args := {}) -> void:
	.enter()
	target_direction = motion.get_input_direction()
	if not target_direction:
		target_direction = Vector2(owner.pivot.scale.x, 0.0).normalized()
	motion.steering.velocity = target_direction * initial_speed

	owner.set_collision_mask_bit(DROP_THRU_BIT, false)
	
	call_deferred("_rotate")
	if owner.pivot.has_node("QuickAttackTrailingSprites"):
		owner.pivot.get_node("QuickAttackTrailingSprites").visible = true


func exit() -> void:
	.exit()
	owner.set_collision_mask_bit(DROP_THRU_BIT, true)
	if owner.pivot.has_node("QuickAttackTrailingSprites"):
		owner.pivot.get_node("QuickAttackTrailingSprites").visible = false


func move(move_direction : Vector2) -> void:
	.move(move_direction)
	var angle = motion.total_velocity.angle()
	if abs(angle - Vector2.UP.angle()) <= PI / 4:
		owner.animation_player.play(up_animation)
	elif abs(angle - Vector2.DOWN.angle()) <= PI / 4:
		owner.animation_player.play(down_animation)
	else:
		owner.animation_player.play(horizontal_animation)

extends Attack
class_name Block

signal blocked
signal blocked_with_position(position)

export(PackedScene) var block_particles : PackedScene
export(float) var degrees_of_protection : float = 90


func enter(args:={}) -> void:
	owner.state = owner.States.INVINCIBLE
	if not owner.Hurtbox.is_connected("area_entered", self, "_on_Hurtbox_area_entered"):
		owner.Hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered")
	.enter()


func exit() -> void:
	if owner.Hurtbox.is_connected("area_entered", self, "_on_Hurtbox_area_entered"):
		owner.Hurtbox.disconnect("area_entered", self, "_on_Hurtbox_area_entered")
	owner.state = owner.States.NORMAL
	.exit()


func _on_Hurtbox_area_entered(area):
	if not area is DamageSource or area.friendly_teams.has(owner.team):
		return
	
	if not _check_if_blocked(area):
		owner.state = owner.States.NORMAL
		owner._on_Hurtbox_area_entered(area)
		return
	
	emit_signal("blocked")
	emit_signal("blocked_with_position", area.global_position)
	
	if area.owner is Projectile:
		area.confirm_hit()


func _check_if_blocked(area) -> bool:
	var defense_angle = owner.global_rotation_degrees
	var angle_to_area = rad2deg((area.global_position - owner.global_position).angle())
	return abs(fmod((fmod(angle_to_area, 360) - fmod(defense_angle, 360)), 360)) < abs(degrees_of_protection)
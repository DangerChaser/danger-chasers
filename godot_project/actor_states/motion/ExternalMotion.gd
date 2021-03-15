extends Node
class_name ExternalMotion

const SPEED_BUFFER := 6.0

var velocity : Vector2
var target_direction := Vector2.UP
var target_speed := 0.0
var mass := 1.0


func apply(direction:Vector2, force:float, initial_mass:float) -> void:
	target_direction = direction
	mass = initial_mass
	var target_position = direction * force + owner.global_position
	velocity = Steering.follow(velocity, owner.global_position, target_position, force * owner.global_scale.length(), 1)


func set_target_speed(new_target_speed : float) -> void:
	target_speed = new_target_speed


func set_mass(new_mass : float) -> void:
	mass = new_mass


func move() -> void:
	if target_speed < SPEED_BUFFER and velocity.length() < SPEED_BUFFER:
		return
	var target_position : Vector2 = owner.global_position + target_direction.normalized() * target_speed
	velocity = Steering.follow(velocity, owner.global_position, target_position, target_speed * owner.global_scale.length(), mass)
#	owner.move_and_slide(velocity, Vector2.UP)


func exit():
	velocity = Vector2()

extends Node
class_name MotionSteering

export var max_speed := 300.0
export var mass := 4.0
export var arrive_distance := -1.0 # Set to a negative value to never "jump" to the destination
export var slow_radius := 50.0
export var slow_down_if_faster_than_max_speed := true

var velocity : Vector2
var max_speed_reached_currently := 0.0


func enter(args := {}) -> void:
	max_speed_reached_currently = 0
	if args.has("velocity"):
		velocity = args["velocity"]

func exit() -> void:
	velocity = Vector2()


func move(direction : Vector2) -> void:
	var target_position = owner.global_position + direction.normalized() * max_speed if direction else owner.global_position
	max_speed_reached_currently = max(max_speed_reached_currently, velocity.length())
	var target_speed = max_speed if slow_down_if_faster_than_max_speed else max(max_speed, max_speed_reached_currently)
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, target_speed, mass, slow_radius)


func move_to(target_position : Vector2) -> void:
	max_speed_reached_currently = max(max_speed_reached_currently, velocity.length())
	var target_speed = max_speed if slow_down_if_faster_than_max_speed else max(max_speed, max_speed_reached_currently)
	velocity = Steering.arrive_to(velocity, owner.global_position, target_position, target_speed, mass, slow_radius)
#	owner.move_and_slide_with_snap(velocity - owner.get_floor_velocity(), snap, Vector2.UP, true)
	if owner.global_position.distance_to(target_position) < arrive_distance:
		owner.global_position = target_position

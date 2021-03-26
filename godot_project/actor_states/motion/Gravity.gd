extends Node
class_name Gravity

export var gravity := 900.0
export var max_speed := 500.0
export var direction := Vector2.DOWN
onready var snap = Vector2.DOWN * 8

var speed : float
var velocity := Vector2()
var enabled := true


func exit() -> void:
	speed = 0
	velocity = Vector2.ZERO


func apply(delta : float) -> void:
	if not enabled:
		return
	
	if owner.is_on_floor():
#		var floor_velocity = owner.get_floor_velocity()
#		speed = floor_velocity.y
		speed = 0.0
		velocity = Vector2()
	else:
		speed = min(speed + gravity * delta, max_speed)
		velocity = direction * speed
#	owner.move_and_slide_with_snap(velocity + owner.get_floor_velocity(), snap, -direction, true)
#	owner.move_and_slide(velocity, -direction, true)


func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

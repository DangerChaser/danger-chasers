extends Node
class_name Gravity

export(float) var gravity := 3600.0
export(float) var max_speed := 2000.0
export(Vector2) var direction := Vector2.DOWN
onready var snap = Vector2.DOWN * 32

var speed : float
var velocity := Vector2()
var enabled := true


func exit() -> void:
	speed = 0


func apply(delta : float) -> void:
	if not enabled:
		return
	
	if owner.is_on_floor():
#		var floor_velocity = owner.get_floor_velocity()
#		speed = floor_velocity.y
		speed = 0.0
		velocity = direction * speed
		return
	else:
		speed = min(speed + gravity * delta, max_speed)
		velocity = direction * speed
#	owner.move_and_slide_with_snap(velocity + owner.get_floor_velocity(), snap, -direction, true)
#	owner.move_and_slide(velocity, -direction, true)


func enable() -> void:
	enabled = true

func disable() -> void:
	enabled = false

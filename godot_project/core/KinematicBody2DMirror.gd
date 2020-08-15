### Flips the KinematicBody2D on the X-Axis based on its current rotation ###
tool
extends KinematicBody2D
class_name KinematicBody2DMirror

var look_direction := Vector2.RIGHT

func set_rotation(value : float) -> void:
	rotation = value
	_correct_rotation()

func set_rotation_degrees(value : float) -> void:
	rotation_degrees = value
	_correct_rotation()

func _correct_rotation():
	# Check which direction the KinematicBody2D is facing
	if cos(rotation) > 0.0:
		look_direction = Vector2.RIGHT
		scale = scale.abs()
	elif cos(rotation) < 0.0:
		look_direction = Vector2.LEFT
		scale = Vector2(abs(scale.x), -abs(scale.y))

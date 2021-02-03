''' Flips the KinematicBody2D on the X-Axis based on its current rotation '''
''' Assumes 0 degrees is the right vector '''
extends KinematicBody2D
class_name MirrorBody2D

var look_direction := Vector2.RIGHT

func set_rotation(value : float) -> void:
	value = fmod(value, 2 * PI)
	rotation = value
	_correct_rotation()

func set_rotation_degrees(value : float) -> void:
	value = fmod(value, 360)
	rotation_degrees = value
	_correct_rotation()

func set_scale(value : Vector2) -> void:
	print_debug("Error: can't manually set scale on a MirrorBody2D")

func _correct_rotation():
	# Check which direction the KinematicBody2D is facing
	# if rotation is 0.0, do nothing
	if cos(rotation) > 0.0:
		look_direction = Vector2.RIGHT
		scale = scale.abs()
	elif cos(rotation) < 0.0:
		look_direction = Vector2.LEFT
		scale = Vector2(abs(scale.x), -abs(scale.y))

func face_object(object) -> void:
	var direction = global_position.direction_to(object.global_position)
	if not direction.x == 0.0:
		var look_direction = Vector2.RIGHT if direction.x > 0 else Vector2.LEFT
		set_rotation(look_direction.angle())

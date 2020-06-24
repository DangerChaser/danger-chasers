extends KinematicBody2D
class_name KinematicBody2DMirror

var look_direction : Vector2 = Vector2.RIGHT # Unit vector
onready var target_rotation = rotation # The actual rotation you want this object to face towards

func set_rotation(value : float) -> void:
	target_rotation = fmod(value, 2 * PI)
	rotation = target_rotation
	if cos(target_rotation) > 0.0: # Check if facing right
		look_direction = Vector2.RIGHT
		scale = Vector2(abs(scale.x), abs(scale.y))
	elif cos(target_rotation) < 0.0 :
		look_direction = Vector2.LEFT
		scale = Vector2(-abs(scale.x), abs(scale.y))
		rotation += PI

func get_rotation() -> float:
	return target_rotation

func update_look_direction(_look_direction : Vector2) -> void:
	set_rotation(_look_direction.angle())

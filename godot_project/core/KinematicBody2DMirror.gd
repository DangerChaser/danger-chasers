extends KinematicBody2D
class_name KinematicBody2DMirror

var look_direction : Vector2 = Vector2.RIGHT # Unit vector
onready var pivot := $Pivot
onready var collider := $CollisionBox

func set_rotation(value : float) -> void:
	rotation = value
	if cos(value) >= 0.0: # Check if facing right
		look_direction = Vector2.RIGHT
		scale = scale.abs()
#		pivot.scale = pivot.scale.abs()
	else:
		look_direction = Vector2.LEFT
		scale = Vector2(abs(scale.x), -abs(scale.y))
#		pivot.scale = Vector2(abs(pivot.scale.x), -abs(pivot.scale.y))

func update_look_direction(_look_direction : Vector2) -> void:
	set_rotation(_look_direction.angle())

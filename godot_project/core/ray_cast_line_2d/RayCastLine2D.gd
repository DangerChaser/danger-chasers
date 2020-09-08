extends RayCast2D
class_name RayCastLine2D

export var ray_cast_collide := false

onready var line : Line2D = $Line2D
var length : float


func _ready() -> void:
	line.points[0] = Vector2.ZERO


func line_cast() -> void:
	length = cast_to.x
	if ray_cast_collide and get_collider():
		length = (global_position - get_collision_point()).length()
	line.points[1] = Vector2(length, 0)


func enable() -> void:
	enabled = true
	force_raycast_update()
	line_cast()
	line.visible = true


func disable() -> void:
	enabled = false
	line.visible = false

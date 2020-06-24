extends RayCast2D
class_name RayCastLine2D


onready var line : Line2D = $Line2D
var length : float


func _ready() -> void:
	line.points[0] = Vector2.ZERO


func line_cast() -> void:
	length = (global_position - get_collision_point()).length() if get_collider() else cast_to.x
	line.points[1] = Vector2(length, 0)


func enable() -> void:
	enabled = true
	force_raycast_update()
	line_cast()
	line.visible = true


func disable() -> void:
	enabled = false
	line.visible = false

tool
extends Node2D
class_name CameraLimitPositions

func get_limit_left() -> float:
	return $TopLeft.global_position.x

func get_limit_top() -> float:
	return $TopLeft.global_position.y

func get_limit_right() -> float:
	return $BottomRight.global_position.x

func get_limit_bottom() -> float:
	return $BottomRight.global_position.y


#########################
## Editor drawing code ##
#########################
export var line_color := Color("80aff2")
export var line_width := 10.0


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	if not Engine.editor_hint:
		return
	
	var points := PoolVector2Array()
	points.append($TopLeft.position)
	points.append(Vector2($BottomRight.position.x, $TopLeft.position.y))
	points.append($BottomRight.position)
	points.append(Vector2($TopLeft.position.x, $BottomRight.position.y))
	points.append($TopLeft.position)
	draw_polyline(points, line_color, line_width)

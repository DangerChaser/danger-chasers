tool
extends Position2D

class_name SpawnPoint

export var DRAW_COLOR : = Color("#e231b6")
export var transition_out_animation : String = "left_to_right"
export var transition_out_duration := 0.5

func _draw() -> void:
	if not Engine.editor_hint:
		return
	var size := Vector2(64, 64)
	var rect := Rect2(-size / 2, size)
	draw_rect(rect, DRAW_COLOR, false)


func spawn() -> void:
	$CameraLimitTrigger.change()
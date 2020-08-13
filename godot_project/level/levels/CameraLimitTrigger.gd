extends Area2D
class_name CameraLimitTrigger

signal started

onready var camera_limit_positions : CameraLimitPositions = $CameraLimitPositions

export var zoom : Vector2 = Vector2(1.4, 1.4)
export var limits_tween_duration := 0.0
export var zoom_tween_duration := 0.0
export var change_limits := true
export var change_zoom := true


var previous_limit_left : float
var previous_limit_top : float
var previous_limit_right : float
var previous_limit_bottom : float
var previous_zoom : Vector2


func _on_CameraLimitTrigger_area_entered(area):
	if not area is ActivationArea or not area.owner is PlayerActor:
		return
	change()


func change() -> void:
	if change_limits:
		_change_limits(camera_limit_positions.get_limit_left(), \
				camera_limit_positions.get_limit_top(), \
				camera_limit_positions.get_limit_right(), \
				camera_limit_positions.get_limit_bottom())
	if change_zoom:
		_change_zoom(zoom)


func reset() -> void:
	if change_limits:
		_change_limits(previous_limit_left, previous_limit_top, previous_limit_right, previous_limit_bottom)
	if change_zoom:
		_change_zoom(previous_zoom)


func _change_limits(limit_left : float, limit_top : float, limit_right : float, limit_bottom : float) -> void:
	previous_limit_left = GameManager.current_camera.limit_left
	previous_limit_top = GameManager.current_camera.limit_top
	previous_limit_right = GameManager.current_camera.limit_right
	previous_limit_bottom = GameManager.current_camera.limit_bottom
	
	GameManager.current_camera.change_limits(limit_left, limit_top, limit_right, limit_bottom, limits_tween_duration)
	emit_signal("started")


func _change_zoom(new_zoom : Vector2) -> void:
	previous_zoom = GameManager.current_camera.zoom
	GameManager.current_camera.change_target_zoom(new_zoom, zoom_tween_duration)

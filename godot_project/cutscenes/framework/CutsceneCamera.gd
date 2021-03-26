extends Camera2D

onready var tween : Tween = $Tween
onready var screen_shake = $ScreenShake

export var tween_duration := 0.5
export var initial_lerp := 0.02

var current_camera : Camera2D
var original_zoom : Vector2

var reset_limit_left
var reset_limit_top
var reset_limit_right
var reset_limit_bottom
var lerp_value : float



func _ready() -> void:
	set_physics_process(false)


func enable(_tween_duration := -1.0) -> void:
	current_camera = GameManager.current_camera
	if not current_camera:
		current_camera = self
		current = true
	
	current_camera.set_physics_process(false)
	current_camera.smoothing_enabled = false
	reset_limit_left = current_camera.limit_left
	reset_limit_top = current_camera.limit_top
	reset_limit_right = current_camera.limit_right
	reset_limit_bottom = current_camera.limit_bottom
	current_camera.limit_left = -10000000
	current_camera.limit_top = -10000000
	current_camera.limit_right = 10000000
	current_camera.limit_bottom = 10000000
	original_zoom = current_camera.zoom
	
	_tween_duration = tween_duration if _tween_duration <= 0 else tween_duration
	tween.interpolate_property(self, "lerp_value", initial_lerp, 0.1, _tween_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()
	
	set_physics_process(true)


func disable(_tween_duration := -1.0) -> void:
	_tween_duration = tween_duration if _tween_duration <= 0 else tween_duration
	tween.interpolate_property(self, "lerp_value", initial_lerp, 0.1, _tween_duration, Tween.TRANS_EXPO, Tween.EASE_IN)
	tween.start()
	
	current_camera.limit_left = reset_limit_left
	current_camera.limit_top = reset_limit_top
	current_camera.limit_right = reset_limit_right
	current_camera.limit_bottom = reset_limit_bottom
	current_camera.smoothing_enabled = true
	
	set_physics_process(false)
	current_camera.set_physics_process(true)


func _physics_process(delta) -> void:
	current_camera.global_position = lerp(current_camera.global_position, global_position, lerp_value)
	current_camera.offset = lerp(current_camera.offset, offset, lerp_value)
	current_camera.zoom = lerp(current_camera.zoom, zoom, lerp_value)


func request_shake(_amplitude := -1.0, _duration := -1.0, _damp := -1.0) -> void:
	screen_shake.request_shake(_amplitude, _duration, _damp)


func _on_Tween_tween_all_completed():
	lerp_value = 0.1

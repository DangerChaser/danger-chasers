extends Camera2D

onready var tween : Tween = $Tween
onready var disable_tween : Tween = $DisableTween
onready var screen_shake = $ScreenShake

export var enable_tween_duration := 0.5
export var disable_tween_duration := 0.5

var current_camera
var original_zoom : Vector2



func _ready() -> void:
	set_physics_process(false)


func enable(tween_duration := -1.0) -> void:
	current_camera = GameManager.current_camera
	if not original_zoom:
		original_zoom = current_camera.zoom
	
	print_debug(current_camera.name)
	
	var _tween_duration = enable_tween_duration if tween_duration < 0 else tween_duration
	tween.interpolate_property(current_camera, "zoom", original_zoom, zoom, _tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(current_camera, "global_position", current_camera.global_position, global_position, _tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()


func disable(tween_duration := -1.0) -> void:
	set_physics_process(false)
	tween.stop_all()
	var _tween_duration = disable_tween_duration if tween_duration < 0 else tween_duration
	disable_tween.interpolate_property(current_camera, "zoom", zoom, original_zoom, _tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	disable_tween.start()


func _physics_process(delta) -> void:
	current_camera.global_position = global_position
	current_camera.offset = offset
	current_camera.zoom = zoom


func request_shake(_amplitude := -1.0, _duration := -1.0, _damp := -1.0) -> void:
	screen_shake.request_shake(_amplitude, _duration, _damp)


func _on_Tween_tween_all_completed():
	set_physics_process(true)

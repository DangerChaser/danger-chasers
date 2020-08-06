extends Camera2D
class_name ShakingCamera

onready var timer := Timer.new()
onready var tween := $Tween

export var amplitude : = 6.0
export var duration : = 0.8 setget set_duration
export(float, EASE) var DAMP_EASING : = 1.0
export var shake : = false setget set_shake

export var enabled : bool = true
var target_zoom := Vector2(1, 1)
var zoom_lerp_value := 0.1

var target_limit_left := -10000000
var target_limit_top := -10000000
var target_limit_right = 10000000
var target_limit_bottom = 10000000
var limits_lerp_value := 0.1

enum States { NORMAL, CUTSCENE }
var state


func _ready() -> void:
	state = States.NORMAL
	
	target_zoom = zoom
	
	timer.connect("timeout", self, "_on_timeout")
	timer.one_shot = true
	add_child(timer)
	randomize()
	set_process(false)
	self.duration = duration


func _process(delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)


var original_zooms : Dictionary
var original_motion_scales : Dictionary
var original_motion_mirroring : Dictionary
func _physics_process(delta : float) -> void:
	# I put zoom code in here instead of _process because I'm a bad coder
	# And don't feel like separating the logic of zooming from this script at this moment
	zoom = lerp(zoom, target_zoom, zoom_lerp_value)
	
	limit_left = lerp(limit_left, target_limit_left, limits_lerp_value)
	limit_top = lerp(limit_top, target_limit_top, limits_lerp_value)
	limit_right = lerp(limit_right, target_limit_right, limits_lerp_value)
	limit_bottom = lerp(limit_bottom, target_limit_bottom, limits_lerp_value)


func change_target_zoom(new_target_zoom : Vector2, new_zoom_lerp_value := 0.1) -> void:
	target_zoom = new_target_zoom
	zoom_lerp_value = new_zoom_lerp_value


func _on_timeout() -> void:
	offset = Vector2()
	self.shake = false


func request_shake(_amplitude := -1.0, _duration := -1.0, _damp := -1.0) -> void:
	if not enabled:
		return
	var amplitude_threshold = 0.0
	var duration_threshold = 0.0
	var damp_threshold = 0.0
	if shake == true:
		if _amplitude > amplitude:
			amplitude_threshold = amplitude
		if _duration > duration:
			duration_threshold = duration
	if _amplitude > amplitude_threshold:
		amplitude = _amplitude
	if _duration > duration_threshold:
		duration = _duration
	if _damp > damp_threshold:
		DAMP_EASING = _damp
	self.shake = true


func set_duration(value: float) -> void:
	duration = value
	timer.wait_time = duration


func set_shake(value: bool) -> void:
	shake = value
	set_process(shake)
	offset = Vector2()
	if shake:
		timer.start(duration)


func set_amplitude(value : float) -> void:
	amplitude = value


func change_limits(limit_left : float, limit_top : float, limit_right : float, limit_bottom : float, _limits_lerp_value := 0.1):
	target_limit_left = limit_left
	target_limit_top = limit_top
	target_limit_right = limit_right
	target_limit_bottom = limit_bottom
	
	limits_lerp_value = _limits_lerp_value


func change_state(new_state) -> void:
	state = new_state

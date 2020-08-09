extends Camera2D
class_name ShakingCamera

onready var timer : Timer = $Timer
onready var tween : Tween = $Tween

export var shake : = false setget set_shake
export var enabled : bool = true
export var position_lerp := 0.1

var amplitude := 6.0
var duration := 0.8 setget set_duration
var DAMP_EASING := 1.0


func _ready() -> void:
	set_process(false)


func _process(delta: float) -> void:
	var damping : = ease(timer.time_left / timer.wait_time, DAMP_EASING)
	offset = Vector2(
		rand_range(amplitude, -amplitude) * damping,
		rand_range(amplitude, -amplitude) * damping)


func _physics_process(delta : float) -> void:
	if GameManager.players.size() > 0:
		global_position = lerp(global_position, GameManager.get_player().get_node("CameraTargetPosition").global_position, position_lerp)


func change_target_zoom(new_zoom : Vector2, tween_duration : float) -> void:
	tween.stop(self, "zoom")
	tween.interpolate_property(self, "zoom", zoom, new_zoom, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()


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
		set_duration(_duration)
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


func change_limits(new_limit_left : float, \
		new_limit_top : float, \
		new_limit_right : float, \
		new_limit_bottom : float, \
		tween_duration : float) -> void:
	tween.stop(self, "limit_left")
	tween.stop(self, "limit_top")
	tween.stop(self, "limit_right")
	tween.stop(self, "limit_bottom")
	tween.interpolate_property(self, "limit_left", limit_left, new_limit_left, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "limit_top", limit_top, new_limit_top, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "limit_right", limit_right, new_limit_right, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "limit_bottom", limit_bottom, new_limit_bottom, tween_duration, Tween.TRANS_QUAD, Tween.EASE_IN_OUT)
	tween.start()

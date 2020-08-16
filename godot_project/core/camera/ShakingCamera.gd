extends Camera2D
class_name ShakingCamera

onready var timer : Timer = $Timer
onready var tween : Tween = $Tween

export var position_lerp := 0.1

var amplitude := 6.0
var damping := 1.0


func _ready() -> void:
	set_process(false)

func _process(delta: float) -> void:
	shake()

func _physics_process(delta : float) -> void:
	if PlayerManager.player:
		global_position = lerp(global_position, PlayerManager.player.get_node("CameraTargetPosition").global_position, position_lerp)

func change_target_zoom(new_zoom : Vector2, tween_duration : float) -> void:
	tween.stop(self, "zoom")
	tween.interpolate_property(self, "zoom", zoom, new_zoom, tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func change_limits(new_limit_left : float, new_limit_top : float, 
					new_limit_right : float, new_limit_bottom : float, \
					tween_duration : float) -> void:
	tween.stop(self, "limit_left")
	tween.stop(self, "limit_top")
	tween.stop(self, "limit_right")
	tween.stop(self, "limit_bottom")
	tween.interpolate_property(self, "limit_left", limit_left, new_limit_left, \
							tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "limit_top", limit_top, new_limit_top, \
							tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "limit_right", limit_right, new_limit_right, \
							tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.interpolate_property(self, "limit_bottom", limit_bottom, new_limit_bottom, \
							tween_duration, Tween.TRANS_SINE, Tween.EASE_IN_OUT)
	tween.start()

func request_shake(new_amplitude : float, \
					duration : float, \
					new_damping : float) -> void:
	amplitude = new_amplitude if new_amplitude > amplitude else amplitude
	damping = new_damping
	match Settings.screen_shake:
		Settings.ScreenShakeIntensity.DISABLED:
			amplitude = 0
		Settings.ScreenShakeIntensity.LOW:
			amplitude *= 0.5
		Settings.ScreenShakeIntensity.HIGH:
			amplitude *= 2
		Settings.ScreenShakeIntensity.EXTREME:
			amplitude *= 3
			duration *= 3
		Settings.ScreenShakeIntensity.VOMIT:
			amplitude *= 5
			duration *= 5
	timer.wait_time = duration
	timer.stop()
	timer.start()
	set_process(true)

func shake() -> void:
	if Settings.ScreenShakeIntensity.DISABLED:
		return
	
	var _damping := ease(timer.time_left / timer.wait_time, damping)
	amplitude *= _damping
	offset = Vector2(rand_range(amplitude, -amplitude), rand_range(amplitude, -amplitude))

func _on_Timer_timeout():
	set_process(false)

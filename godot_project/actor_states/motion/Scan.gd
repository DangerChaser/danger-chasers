extends MotionState

export var animation : String = "idle"
export var max_rotation_degrees = 90
export var min_rotation_degrees = -90
export var scan_one_way_duration := 2.0
export var lock_on_time := 1.0
export var next_state : String = ""
export var timeout_duration := -1.0
export var locked_on_lerp := 6.0
export var active_time := 5.0

onready var timer : Timer = $Timer
onready var tween : Tween = $Tween
onready var lock_on_timer : Timer = $LockOnTimer
onready var raycast_line : RayCastLine2D = $RayCastLine2DVisuals
onready var active_timer : Timer = $ActiveTimer

var going_up := true
var initial_rotation_degrees : float
var target_angle : float
var locked_on := false


func _ready() -> void:
	lock_on_timer.wait_time = lock_on_time
	active_timer.wait_time = active_time


func enter(args := {}) -> void:
	.enter(args)
	initial_rotation_degrees = owner.rotation_degrees
	owner.play_animation(animation)
	
	if timeout_duration > 0.0:
		timer.wait_time = timeout_duration
		timer.start()
	
	raycast_line.enable()
	sweep(true)
	
	locked_on = false
	set_physics_process(locked_on)


func sweep(up := true) -> void:
	$ScanSfx.play()
	
	going_up = up
	
	var new_target_angle
	if up:
		new_target_angle = initial_rotation_degrees + max_rotation_degrees 
	else:
		new_target_angle = initial_rotation_degrees + min_rotation_degrees
	tween.stop_all()
	tween.interpolate_method(owner, "set_rotation_degrees", target_angle, new_target_angle, scan_one_way_duration, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
	tween.resume_all()
	target_angle = new_target_angle


func exit() -> void:
	.exit()
	timer.stop()
	raycast_line.disable()
	$TargetConfirmedSfx.stop()


func _process(delta):
	raycast_line.line_cast()


func _physics_process(delta) -> void:
	var lerped_angle = lerp_angle(owner.rotation, \
			(owner.target.global_position - owner.global_position).angle(), \
			locked_on_lerp * delta)
	owner.set_rotation(lerped_angle)
	
	if $CollisionTrigger.get_overlapping_bodies().size() > 0 \
			and is_instance_valid(owner.target.get_target()) \
			and $CollisionTrigger.get_overlapping_bodies()[0] == owner.target.get_target().owner:
		active_timer.start()


func _on_Tween_tween_all_completed():
	if going_up:
		sweep(false)
	else:
		sweep(true)


func _on_CollisionTrigger_area_entered(area):
	if not locked_on:
		lock_on(area.owner)


func _on_CollisionTrigger_body_entered(body):
	if not locked_on:
		lock_on(body)


func lock_on(target) -> void:
	owner.target.lock_on(target)
	tween.stop_all()
	lock_on_timer.start()
	locked_on = true
	set_physics_process(locked_on)
	$LockOnSfx.play()


func _on_LockOnTimer_timeout():
	if $CollisionTrigger.get_overlapping_bodies().size() > 0 and $CollisionTrigger.get_overlapping_bodies()[0] == owner.target.get_target().owner:
		$TargetConfirmedSfx.play()
		active_timer.start()
	else:
		lost_target()


func _on_ActiveTimer_timeout():
	lost_target()


func lost_target() -> void:
	set_physics_process(false)
	locked_on = false
	$TargetLostSfx.play()
	$TargetConfirmedSfx.stop()
	active_timer.stop()
	lock_on_timer.stop()
	
	going_up = true
	var new_target_angle = initial_rotation_degrees + max_rotation_degrees
	target_angle = new_target_angle
	tween.interpolate_method(owner, "set_rotation_degrees", owner.rotation_degrees, new_target_angle, scan_one_way_duration, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
	tween.resume_all()









func _on_Timer_timeout():
	finished(next_state)


func pause() -> void:
	.pause()
	timer.paused = true
	lock_on_timer.paused = true
	active_timer.paused = true
	set_physics_process(false)

func unpause() -> void:
	.unpause()
	timer.paused = false
	lock_on_timer.paused = false
	active_timer.paused = false
	set_physics_process(locked_on)

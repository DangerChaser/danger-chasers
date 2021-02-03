extends MotionState

export var weapon_scene : PackedScene
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
var weapon


func _ready() -> void:
	lock_on_timer.wait_time = lock_on_time
	active_timer.wait_time = active_time
	set_weapon(weapon_scene)

func set_weapon(weapon_scene : PackedScene) -> void:
	weapon = weapon_scene.instance()
	weapon.set_friendly_teams([owner.team])
	owner.add_weapon(weapon)
	weapon.set_owner(owner)
	weapon.connect("attack_started", self, "attack_started")


func attack_started(attack_animation : String) -> void:
	owner.play_animation(attack_animation)


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
	weapon.exit()
	timer.stop()
	raycast_line.disable()
	$TargetConfirmedSfx.stop()


func _process(delta):
	raycast_line.line_cast()


func _physics_process(delta) -> void:
	if not locked_on:
		if raycast_line.get_collider() is Actor:
			lock_on(raycast_line.get_collider())
		return
	
	if raycast_line.get_collider() is Actor:
		owner.target.lock_on(raycast_line.get_collider())
		active_timer.start()
	
	if owner.target.get_target():
		var lerped_angle = lerp_angle(owner.rotation, \
				owner.target.get_rotation_to(), \
				locked_on_lerp * delta)
		owner.set_rotation(lerped_angle)
	
	weapon.attacks.register_attack()


func _on_Tween_tween_all_completed():
	if going_up:
		sweep(false)
	else:
		sweep(true)


func lock_on(target) -> void:
	owner.target.lock_on(target)
	tween.stop_all()
	lock_on_timer.start()
	locked_on = true
	$LockOnSfx.play()


func _on_LockOnTimer_timeout():
	if raycast_line.get_collider() is Actor:
		owner.target.lock_on(raycast_line.get_collider())
		$TargetConfirmedSfx.play()
		active_timer.start()
		weapon.enter()
	else:
		lost_target()


func _on_ActiveTimer_timeout():
	lost_target()


func lost_target() -> void:
	locked_on = false
	$TargetLostSfx.play()
	$TargetConfirmedSfx.stop()
	active_timer.stop()
	lock_on_timer.stop()
	weapon.exit()
	
	going_up = true
	var new_target_angle = initial_rotation_degrees + max_rotation_degrees
	target_angle = new_target_angle
	tween.interpolate_method(owner, "set_rotation_degrees", owner.rotation_degrees, new_target_angle, scan_one_way_duration, Tween.TRANS_QUAD,Tween.EASE_IN_OUT)
	tween.start()
	tween.resume_all()









func _on_Timer_timeout():
	finished(next_state)


func pause() -> void:
	pass
#	.pause()
#	timer.paused = true
#	lock_on_timer.paused = true
#	active_timer.paused = true

func unpause() -> void:
	pass
#	.unpause()
#	timer.paused = false
#	lock_on_timer.paused = false
#	active_timer.paused = false

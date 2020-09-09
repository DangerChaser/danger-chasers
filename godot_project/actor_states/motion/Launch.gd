extends State

export var animation : String = "launch"
export var next_state := ""
export var initial_angle_deg := -90
export var random_angle := 0.0
export var force := 666.0
export var mass := 4.0
export var land_animation := ""

onready var timer : Timer = $Timer
onready var motion : MotionState = $Motion
var time_entered : float

func enter(args := {}) -> void:
	.enter(args)
	motion.enter(args)
	
	time_entered = OS.get_ticks_msec()
	
	var _random_angle = randf() * random_angle * 2 - random_angle
	var direction = Vector2.RIGHT.rotated(deg2rad(initial_angle_deg + _random_angle))
	motion.external.apply(direction, force, 1.0)
	motion.external.set_mass(mass)
	
	var duration = args["duration"] if args.has("duration") else timer.wait_time
	timer.start(duration)
	
	owner.play_animation(animation)


func exit() -> void:
	timer.stop()
	motion.exit()
	set_physics_process(false)


func _on_Timer_timeout():
	finished(next_state)


func _physics_process(delta:float) -> void:
	var current_tick = OS.get_ticks_msec()
	var BUFFER = 100
	if current_tick - time_entered < BUFFER:
		return
	
	if owner.is_on_wall():
		motion.external.velocity.x *= -1
		motion.external.target_direction.x *= -1
	
	if owner.is_on_floor():
		timer.stop()
		var args = { "initial_animation" : land_animation } if land_animation else {}
		finished(next_state, args)


func pause() -> void:
	.pause()
	if timer:
		timer.paused = true


func unpause() -> void:
	.unpause()
	if timer:
		timer.paused = false

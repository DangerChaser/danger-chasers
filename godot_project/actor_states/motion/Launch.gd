extends State

export(String) var animation : String = "launch"
export(String) var next_state := ""
export(float) var initial_angle_deg := -90
export(float) var random_angle := 0.0
export(float) var force := 666.0
export(float) var mass := 4.0
export var land_animation := ""

onready var timer := $Timer
onready var motion := $Motion
var time_entered : float
var target_direction : Vector2

func enter(args := {}) -> void:
	.enter(args)
	motion.enter(args)
	
	time_entered = OS.get_ticks_msec()
	
	var _random_angle = deg2rad(randf() * random_angle)
	var direction = Vector2.RIGHT.rotated(deg2rad(initial_angle_deg) + _random_angle)
	target_direction = Vector2()
	target_direction.x = direction.x * sign(owner.pivot.scale.x)
	direction.x = 0
	motion.external.apply(direction, force, 1.0)
	motion.external.set_mass(mass)
	
	var duration = args["duration"] if args.has("duration") else timer.wait_time
	timer.start(duration)
	
	if owner.animation_player.has_animation(animation):
		owner.animation_player.play(animation)


func exit() -> void:
	timer.stop()
	motion.exit()
	set_physics_process(false)


func _on_Timer_timeout():
	finished(next_state)


func _physics_process(delta:float) -> void:
	motion.steering.move(target_direction)
	
	var current_tick = OS.get_ticks_msec()
	var BUFFER = 100
	if current_tick - time_entered < BUFFER:
		return
	if owner.is_on_floor():
		timer.stop()
		var args = { "initial_animation" : land_animation } if land_animation else {}
		finished(next_state, args)

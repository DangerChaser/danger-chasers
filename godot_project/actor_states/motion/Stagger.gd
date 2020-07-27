extends MotionState
class_name StaggerState

signal revenge_updated(revenge_value, old_revenge_value, revenge_threshold)

export var animation : String = "stagger"
export var next_state : String = ""
export var keep_staggering := true
export var distance_multiplier : float = 1.0
export var use_internal_duration := false
export var finish_on_floor := false
export var invincible := false # Applied only while in stagger, not the hit that enters stagger
export var invincibility_buffer := 0.0 # Buffer applied AFTER stagger ends

export var revenge_threshold := 0.0
export var revenge_state := ""

onready var timer : Timer = $Timer

var start_position : Vector2
var target_position : Vector2
var distance : int
var revenge_value := 0.0


func reset() -> void:
	timer.stop()


func enter(args := {}) -> void:
	.enter(args)
	
	emit_signal("revenge_updated", revenge_value, revenge_value, revenge_threshold)
	
	if args.has("animation"):
		owner.animation_player.play(args["animation"])
	else:
		owner.animation_player.play(animation)
	
	var duration
	if use_internal_duration:
		duration = timer.wait_time
	else:
		duration = args["duration"] if args.has("duration") else 0.01
	var direction = args["direction"] if args.has("direction") else Vector2()
	var force = args["force"] if args.has("force") else 0.0
	var mass = args["mass"] if args.has("mass") else 1.0
	initialize(direction, force, mass, duration)
	
	if invincible:
		var invincibility = Effects.get_effect("Invincible", {"duration" : timer.wait_time})
		owner.buffs.add(invincibility)
	
	timer.start()


func exit() -> void:
	.exit()
	revenge_value = 0.0
	timer.stop()
	if invincibility_buffer > 0:
		var invincibility = Effects.get_effect("Invincible", {"duration" : invincibility_buffer})
		owner.buffs.add(invincibility)


func _physics_process(delta) -> void:
	if finish_on_floor and owner.is_on_floor():
		finished(next_state)


func initialize(direction : Vector2, force : float, initial_mass : int, duration : float) -> void:
	force *= distance_multiplier
	external.velocity = direction * force
	external.apply(direction, force, initial_mass)
	timer.wait_time = duration
	owner.update_look_direction(direction)


func _on_Timer_timeout():
	finished(next_state)


func take_damage(args := {}):
	if revenge_threshold > 0 and args.has("revenge_value"):
		var old_revenge_value = revenge_value
		revenge_value += args["revenge_value"]
		emit_signal("revenge_updated", revenge_value, old_revenge_value, revenge_threshold)
		if revenge_value >= revenge_threshold and owner.state_machine.has_state(revenge_state):
			finished(revenge_state, args)
			return
	
	if keep_staggering:
		enter(args)

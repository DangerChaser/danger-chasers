extends State
class_name IdleState

export(String) var animation := "idle"
export(String) var walk_animation := "walk"
export(String) var run_animation := "run"

const DROP_THRU_BIT = 6

onready var air_timer := $AirTimer
onready var jump_registered_timer := $JumpRegisteredTimer
onready var original_air_timer_duration : float = $AirTimer.wait_time
onready var air_timer_duration := original_air_timer_duration
onready var motion := $Motion
onready var drop_through_timer := $DropThroughTimer

export var stand_still_threshold_percent := 0.25

var jump_registered := false
var active := false


func enter(args := {}) -> void:
	active = true
	.enter(args)
	motion.enter(args)
	
	if jump_registered:
		jump()
		jump_registered_timer.stop()
		return
	
	if args.has("initial_animation"):
		owner.animation_player.play(args["initial_animation"])
		return
	owner.animation_player.play(animation)


func exit() -> void:
	.exit()
	motion.exit()
	active = false
	set_physics_process(true)


func _input(event : InputEvent) -> void:
	if owner.state_machine.has_state("LightAttack") and Input.is_action_just_pressed("light_attack"):
		var args = {"target_direction" : Vector2(Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int , 0) }
		emit_signal("finished", "LightAttack", args)
		return
	if event.is_action_pressed('ui_down'):
		drop_through_timer.start()
		owner.set_collision_mask_bit(DROP_THRU_BIT, false)


func _physics_process(delta : float) -> void:
	if Input.is_action_pressed('ui_up'):
		register_jump()
	
	if not active:
		return
	
	if owner.state_machine.has_state("Stomp") and Input.is_action_pressed('ui_down'):
		air_timer.stop()
		air_timer_duration = 0.05
		if not owner.is_on_floor():
			var args = { "velocity": motion.steering.velocity }
			args["input_key"] = "ui_down"
			args["target_direction"] = Vector2(motion.steering.velocity.x, Vector2.DOWN.y)
			emit_signal("finished", "Stomp", args)
			return
	
	if not owner.is_on_floor():
		if air_timer.time_left <= 0.0:
			air_timer.start(original_air_timer_duration)
	else:
		air_timer.stop()
	
	var direction = Vector2(motion.get_input_direction().x, 0.0)
	motion.move(direction)
	if owner.animation_player.current_animation == animation or owner.animation_player.current_animation == run_animation or owner.animation_player.current_animation == walk_animation:
		if motion.steering.velocity.length() > motion.steering.max_speed * stand_still_threshold_percent:
			owner.animation_player.play(run_animation)
		else:
			owner.animation_player.play(animation)


func take_damage(args := {}):
	air_timer.stop()
	emit_signal("finished", "Stagger", args)



func anim_finished(anim_name : String) -> void:
	owner.animation_player.play(animation)


func jump() -> void:
	if not owner.state_machine.has_state("Up"):
		return
	
	var args = {
		"velocity" : motion.steering.velocity, 
		"gravity_speed" : 0, 
		"target_direction" : Vector2.UP, 
		"input_key" : "ui_up"
	}
	args["target_direction"].x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int 
	air_timer.stop()
	jump_registered = false
	active = false
	set_physics_process(false)
	emit_signal("finished", "Up", args)


func _on_AirTimer_timeout():
	if active and not owner.is_on_floor():
		emit_signal("finished", "Air", {"velocity":motion.steering.velocity, "gravity_speed":0})


func register_jump() -> void:
	if active:
		jump()
		return
	jump_registered = true
	jump_registered_timer.start()


func _on_JumpRegisteredTimer_timeout():
	jump_registered = false
	jump_registered_timer.stop()

func _on_DropThroughTimer_timeout():
	owner.stop_drop_through()

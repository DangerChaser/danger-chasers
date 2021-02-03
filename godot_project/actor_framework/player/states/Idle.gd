extends State
class_name IdleState

export(String) var animation := "idle"
export(String) var walk_animation := "walk"
export(String) var run_animation := "run"

const DROP_THRU_BIT = 6

onready var air_timer := $AirTimer
onready var jump_registered_timer := $JumpRegisteredTimer
onready var motion : MotionState = $Motion
onready var drop_through_timer := $DropThroughTimer

export var stand_still_threshold_percent := 0.25

var jump_registered := false
var active := false


func enter(args := {}) -> void:
	.enter(args)
	motion.enter(args)
	
	if jump_registered:
		jump_registered_timer.stop()
		jump()
		return
	
	if args.has("initial_animation"):
		owner.play_animation(args["initial_animation"])
	else:
		owner.play_animation(animation)
	
	active = true


func exit() -> void:
	.exit()
	motion.exit()
	active = false
	set_process_input(true)


func _input(event : InputEvent) -> void:
	if event.is_action_pressed('ui_up'):
		if not owner.input_enabled:
			return
		register_jump()
	
	if not active:
		return
	
	if not owner.input_enabled:
		return
	if event.is_action_pressed("light_attack") and owner.state_machine.has_state("LightAttack"):
		var args = {"target_direction" : Vector2(Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int , 0) }
		finished("LightAttack", args)
		return
	if event.is_action_pressed('ui_down'):
		drop_through_timer.start()
		owner.set_collision_mask_bit(DROP_THRU_BIT, false)
		
		if owner.state_machine.has_state("Stomp"):
			air_timer.stop()
			if not owner.is_on_floor():
				var args = { "velocity": motion.steering.velocity }
				args["input_key"] = "ui_down"
				args["target_direction"] = Vector2(motion.steering.velocity.x, Vector2.DOWN.y)
				finished("Stomp", args)
				return


func _physics_process(delta : float) -> void:
	if not owner.is_on_floor():
		if air_timer.time_left <= 0.0:
			air_timer.start()
	
	var direction = Vector2(motion.get_input_direction().x, 0.0)
	motion.move(direction)
	
	var current_animation = owner.pivot.animation_player.current_animation
	if current_animation == animation or current_animation == run_animation or current_animation == walk_animation:
		if Input.is_action_pressed("ui_right") or Input.is_action_pressed("ui_left"):
			if not current_animation == run_animation and motion.steering.velocity.length() > motion.LOOK_DIRECTION_SPEED_THRESHOLD:
				owner.play_animation(run_animation)
		elif not current_animation == animation and motion.steering.velocity.length() < motion.steering.max_speed * stand_still_threshold_percent:
			owner.play_animation(animation)


func take_damage(args := {}):
	air_timer.stop()
	finished("Stagger", args)


func anim_finished(anim_name : String) -> void:
	owner.play_animation(animation)


func jump() -> void:
	if not owner.state_machine.has_state("Jump"):
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
	finished("Jump", args)


func _on_AirTimer_timeout():
	if active and not owner.is_on_floor():
		finished("Air", {"velocity":motion.steering.velocity, "gravity_speed":motion.gravity.speed})


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
	owner.set_collision_mask_bit(Utilities.Layers.DROP_THROUGH, true)

extends State

export var wall_state := "Air"
export var floor_state := "Idle"
export var jump_state := "Tricks"
export var jump_force := 5000.0
export var initial_speed := 200.0
export var animation := "run"

onready var motion : MotionState = $Motion
var check_ui_up := false
var current_speed : float

func enter(args := {}) -> void:
	.enter(args)
	
	motion.enter(args)
	owner.play_animation(animation)
	
	var target_direction = motion.get_input_direction()
	target_direction.y = 0
	target_direction = target_direction.normalized()
	if args.has("initial_speed"):
		motion.steering.velocity = target_direction * max(args["initial_speed"], initial_speed)
	else:
		motion.steering.velocity = target_direction * initial_speed
	
	if args.has("velocity"):
		motion.steering.velocity = args["velocity"]
	
	current_speed = initial_speed + sign(initial_speed) * max(motion.steering.max_speed * owner.global_scale.length(), motion.steering.velocity.length())
	motion.steering.velocity.x = target_direction.x * current_speed + owner.get_floor_velocity().x
	motion.steering.velocity.y = 0.0 # Ensures that jump height is even
	
	motion.gravity.speed = 0.0
	
	motion.external.apply(Vector2.UP, jump_force, 1.0) #- owner.get_floor_velocity().y, 1.0)
	motion.external.set_target_speed(0.0)
	motion.external.set_mass(8)
	
	check_ui_up = false
	$UiUpTimer.start()


func exit() -> void:
	.exit()
	motion.exit()
	$UiUpTimer.stop()
	check_ui_up = false


func _physics_process(delta : float) -> void:
	var target_direction = motion.get_input_direction()
	target_direction.y = 0
	target_direction = target_direction.normalized()
	motion.move(target_direction)
	
	if not check_ui_up:
		return
	
	if owner.is_on_floor():
		finished(floor_state)
	if owner.is_on_wall():
		finished(wall_state)
		current_speed = 0
	
	if check_ui_up and Input.is_action_just_pressed("ui_up"):
		finished(jump_state)


func _on_UiUpTimer_timeout():
	check_ui_up = true

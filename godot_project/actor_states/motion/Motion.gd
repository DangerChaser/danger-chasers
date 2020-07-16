extends State
class_name MotionState

export(bool) var look_towards_move_direction := true

const LOOK_DIRECTION_SPEED_THRESHOLD := 6.0

onready var steering := $MotionSteering
onready var gravity := $Gravity
onready var external := $ExternalMotion

var total_velocity := Vector2()
var last_move_direction := Vector2()
var gravity_enabled := true


func _ready() -> void:
	call_deferred("assert", owner is KinematicBody2D)
	for child in get_children():
		child.owner = owner
		child.set_physics_process(false)


func enter(args := {}) -> void:
	.enter(args)
	steering.enter(args)
	if args.has("gravity_speed"):
		gravity.speed = args["gravity_speed"]
	if args.has("external"):
		var external_args = args["external"]
		external.velocity = external_args["velocity"]
		external.target_direction = external_args["target_direction"]
		external.target_speed = external_args["target_speed"]
		external.mass = external_args["mass"]


func exit() -> void:
	.exit()
	steering.exit()
	gravity.exit()


func _physics_process(delta : float) -> void:
	external.move()
	gravity.apply(delta)
	total_velocity = steering.velocity + gravity.velocity + external.velocity


func get_input_direction() -> Vector2:
	var input_direction : Vector2 = Vector2()
	if owner.is_in_group("players"):
		input_direction.x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int
		input_direction.y = Input.is_action_pressed("ui_down") as int - Input.is_action_pressed("ui_up") as int
	return input_direction


func move(move_direction : Vector2) -> void:
	steering.move(move_direction)
	
	var direction = total_velocity.normalized()
	last_move_direction = direction
	if look_towards_move_direction:
		update_look_direction(direction)


func move_to(target_position : Vector2) -> void:
	steering.move_to(target_position)
	
	var direction = total_velocity.normalized()
	last_move_direction = direction
	if look_towards_move_direction:
		update_look_direction(direction)


func update_look_direction(direction : Vector2) -> void:
	if abs(total_velocity.x) < LOOK_DIRECTION_SPEED_THRESHOLD:
		return
	var look_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	owner.update_look_direction(look_direction)


func get_exit_args() -> Dictionary:
	var args = {
		"velocity": steering.velocity, 
		"gravity_speed":gravity.speed,
		"external": {
			"velocity" : external.velocity,
			"target_direction" : external.target_direction,
			"target_speed" : external.target_speed,
			"mass" : external.mass
		}
	}
	return args

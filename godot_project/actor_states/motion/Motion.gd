extends State
class_name MotionState

export var look_towards_move_direction := true
export var look_away_from_move_direction := false

const LOOK_DIRECTION_SPEED_THRESHOLD := 500.0

onready var steering := $MotionSteering
onready var gravity := $Gravity
onready var external := $ExternalMotion

var total_velocity := Vector2()
var last_move_direction := Vector2()
var gravity_enabled := true
var snap := 16.0


func _ready() -> void:
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
	
	total_velocity = steering.velocity + gravity.velocity + external.velocity
	
	var direction = total_velocity.normalized()
	last_move_direction = direction
	if look_towards_move_direction:
		update_look_direction(direction)
	elif look_away_from_move_direction:
		update_look_direction(-direction)
	if args.has("look_direction"):
		update_look_direction(args["look_direction"])


func exit() -> void:
	.exit()
	steering.exit()
	gravity.exit()
	external.exit()


func _physics_process(delta : float) -> void:
	if owner.paused:
		return
	
	external.move()
	gravity.apply(delta)
	total_velocity = steering.velocity + gravity.velocity + external.velocity
	owner.move_and_slide_with_snap(total_velocity, gravity.direction * snap, -gravity.direction, true)
	
	var direction = total_velocity.normalized()
	if look_towards_move_direction:
		update_look_direction(direction)
	elif look_away_from_move_direction:
		update_look_direction(-direction)


func get_input_direction() -> Vector2:
	var input_direction : Vector2 = Vector2()
#	if owner.is_in_group("players"):
	if not owner.input_enabled:
		return Vector2()
	input_direction.x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int
	input_direction.y = Input.is_action_pressed("ui_down") as int - Input.is_action_pressed("ui_up") as int
	return input_direction


func move(move_direction : Vector2) -> void:
	steering.move(move_direction)
	
	var direction = total_velocity.normalized()
	last_move_direction = direction
	if look_towards_move_direction:
		update_look_direction(move_direction)
	elif look_away_from_move_direction:
		update_look_direction(-move_direction)


func move_to(target_position : Vector2) -> void:
	steering.move_to(target_position)
	
	var direction = total_velocity.normalized()
	last_move_direction = direction
	if look_towards_move_direction:
		update_look_direction(direction)
	elif look_away_from_move_direction:
		update_look_direction(-direction)


func update_look_direction(direction : Vector2) -> void:
	if abs(total_velocity.x) < LOOK_DIRECTION_SPEED_THRESHOLD:
		return
	if direction.x == 0:
		return
	var look_direction = Vector2.LEFT if direction.x < 0 else Vector2.RIGHT
	owner.set_rotation(look_direction.angle())


func rotate_to_move_direction() -> void:
	owner.set_rotation(total_velocity.angle())


func get_exit_args() -> Dictionary:
	var args = {
		"velocity": steering.velocity, 
		"initial_speed": steering.velocity.length(),
		"gravity_speed":gravity.speed,
		"external": {
			"velocity" : external.velocity,
			"target_direction" : external.target_direction,
			"target_speed" : external.target_speed,
			"mass" : external.mass
		}
	}
	return args


func pause() -> void:
	.pause()
	set_physics_process(false)


func unpause() -> void:
	.unpause()
	set_physics_process(true)

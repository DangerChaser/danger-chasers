extends AttackAdditionalEffect
class_name MovementEffect

const VECTOR_UP = Vector2(0, -1)

onready var motion : MotionState = $Motion

export var initial_mass = 1.0
export var initial_speed := 840.0 # Positive pushes actor to target
export var actor_rotate := false # Takes priority over weapon_rotate
export var weapon_rotate := false
export var disable_x_input := false
export var disable_y_input := true
export var initialize_x := false
export var initialize_y := false
export var gets_input_direction := false
export var offset := Vector2()
# Don't have both take_previous_velocity and takes_previous_speed on at the same time
export var take_previous_velocity := false
export var takes_previous_speed := false

var target_direction : Vector2
var active := false


func _physics_process(delta:float) -> void:
	if owner.is_in_group("players") or gets_input_direction:
		target_direction = motion.get_input_direction()
	if disable_y_input:
		target_direction.y = 0
	if disable_x_input:
		target_direction.x = 0
	move(target_direction)


func move(move_direction : Vector2) -> void:
	motion.move(move_direction)
	_rotate()


func enter(args := {}) -> void:
	if active:
		return
	
	active = true
	.enter(args)
	
	motion.enter(args)
	
	if args.has("look_direction"):
		motion.update_look_direction(args["look_direction"])
	
	if args.has("target_direction"):
		target_direction = args["target_direction"]
	if not target_direction:
		var angle = owner.get_rotation()
		target_direction = Vector2.RIGHT.rotated(angle)
	if gets_input_direction:
		target_direction = motion.get_input_direction()
	
	if takes_previous_speed and args.has("initial_speed"):
		motion.steering.velocity = target_direction * max(args["initial_speed"], initial_speed)
	else:
		motion.steering.velocity = target_direction * initial_speed
	
	if initialize_x:
		motion.steering.velocity.x = 0
	if initialize_y:
		motion.steering.velocity.y = 0
		motion.gravity.speed = 0.0
		motion.gravity.velocity.y = 0
		motion.external.velocity.y = 0
	
	if args.has("velocity") and take_previous_velocity:
		motion.steering.velocity = args["velocity"]


func exit() -> void:
	target_direction = Vector2()
	active = false
	.exit()
	motion.exit()


func _rotate() -> void:
	if actor_rotate:
		_actor_rotate()
		return
	if weapon_rotate:
		_weapon_rotate()


func _actor_rotate() -> void:
	var direction = Vector2()
	if owner.target and owner.target.get_target():
		direction = owner.global_position.direction_to(owner.target.global_position)
	else:
		direction = motion.total_velocity.normalized()
	owner.set_rotation(direction.angle())


func _weapon_rotate() -> void:
	var direction = motion.total_velocity.normalized()
	if owner.target and owner.target.get_target():
		direction = owner.global_position.direction_to(owner.target.global_position)
	var angle = direction.angle()
	
	if owner is MirrorBody2D and owner.look_direction == Vector2.LEFT:
		angle = PI - angle
	
	weapon.set_rotation(angle)


func get_exit_args() -> Dictionary:
	var args = motion.get_exit_args()
	args["target_direction"] = target_direction
	return args

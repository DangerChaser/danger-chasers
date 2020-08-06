extends MotionState
class_name RunState

export var next_state := ""
export var animation := "run"
export var disable_player_stopper := false
export var to_target := true
export var to_target_position := false
export var stagger := true

onready var timer : Timer = $Timer

var target
var target_position
var target_direction

func enter(args := {}) -> void:
	.enter(args)
	
	timer.start()
	
	owner.play_animation(animation)
	if args.has("target_position"):
		target_position = args["target_position"]
	if args.has("target_direction"):
		target_direction = args["target_direction"]
	
	if disable_player_stopper:
		owner.set_collision_layer_bit(PhysicsLayers.PlayerStoppers, false)


func exit() -> void:
	timer.stop()
	
	if disable_player_stopper:
		owner.set_collision_layer_bit(PhysicsLayers.PlayerStoppers, true)
	target_position = null
	target_direction = null
	.exit()


func _physics_process(delta):
	var _target_position
	if target_position and not to_target:
		_target_position = target_position
	else:
		owner.target.lock_on()
		target = owner.target.get_target()
		_target_position = target.global_position if target else target_position
	var distance = _target_position.x - owner.global_position.x
	
	if abs(distance) < steering.arrive_distance:
		finished(next_state, get_args())
		return
	
	if to_target_position:
		move_to(Vector2(_target_position.x, owner.global_position.y))
		return
	
	var _target_direction : Vector2
	if target_direction:
		_target_direction = target_direction
	elif target:
		_target_direction = Vector2(sign(distance), 0)
	else:
		_target_direction = Vector2(owner.pivot.scale, 0).normalized()
	move(_target_direction)
	
	if owner.is_on_wall():
		finished(next_state, get_args())


func get_args() -> Dictionary:
	var _target_position = Vector2()
	if target_position:
		_target_position = target_position 
	elif owner.target.get_target():
		_target_position = owner.target.get_target().global_position
	var target_direction = (_target_position - owner.global_position).normalized()
	var args = {
		"velocity": steering.velocity, 
		"gravity_speed":gravity.speed,
		"external": {
			"velocity" : external.velocity,
			"target_direction" : external.target_direction,
			"target_speed" : external.target_speed,
			"mass" : external.mass
		},
		"target_direction" : target_direction,
		"target_position" : _target_position
	}
	return args


func _on_Timer_timeout():
	finished(next_state, get_args())


func take_damage(args := {}):
	if stagger:
		finished("Stagger", args)

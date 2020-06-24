extends MovementEffect

export var jump_force := 5000.0
export var finish_on_release := true
export var take_previous_velocity := true

var input : String
var current_speed : float

func _ready() -> void:
	motion.steering.snap = Vector2()


func enter(args := {}) -> void:
	var weapon = get_parent().get_parent().get_parent().get_parent().get_parent()
	input = weapon.input
	
	target_direction.x = 0
	.enter(args)
	if args.has("velocity") and take_previous_velocity:
		motion.steering.velocity = args["velocity"]
	
	current_speed = initial_speed + max(motion.steering.max_speed * owner.global_scale.length(), motion.steering.velocity.length())
	motion.steering.velocity.x = target_direction.x * current_speed + owner.get_floor_velocity().x
	motion.steering.velocity.y = 0.0 # Ensures that jump height is even
	
	motion.gravity.speed = 0.0
	
	motion.external.apply(Vector2.UP, jump_force - owner.get_floor_velocity().y, 1.0)
	motion.external.set_target_speed(0.0)
	motion.external.set_mass(initial_mass)


func _physics_process(delta : float) -> void:
	if owner.is_on_wall():
		motion.steering.velocity.x = 0
		current_speed = 0
	
	if Input.is_action_just_released(input):
		if finish_on_release:
			emit_signal("finished")

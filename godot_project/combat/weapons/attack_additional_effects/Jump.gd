extends MovementEffect

export var jump_force := 1300.0
export var finish_on_release := true
export var jump_particles : PackedScene

var input : String
var current_speed : float


func _ready() -> void:
	motion.snap = 0.0
	if not $SfxParticleSpawner.object:
		$SfxParticleSpawner.object = jump_particles


func enter(args := {}) -> void:
	$SquashStretchTween.begin()
	$SfxParticleSpawner.spawn()
	
	motion.snap = 0.0
	var weapon = get_parent().get_parent().get_parent().get_parent().get_parent()
	input = weapon.input
	
	.enter(args)
	
	current_speed = initial_speed + sign(initial_speed) * max(motion.steering.max_speed * owner.global_scale.length(), motion.steering.velocity.length())
	motion.steering.velocity.x = target_direction.x * current_speed + owner.get_floor_velocity().x
	motion.steering.velocity.y = 0.0 # Ensures that jump height is even
	
	motion.gravity.speed = 0.0
	
	motion.external.apply(Vector2.UP, jump_force, 1.0) #- owner.get_floor_velocity().y, 1.0)
	motion.external.set_target_speed(0.0)
	motion.external.set_mass(initial_mass)


func _physics_process(delta : float) -> void:
	if owner.is_on_wall():
		motion.steering.velocity.x = 0
		current_speed = 0
	
	if finish_on_release and Input.is_action_just_released(input):
		finished()


func get_exit_args() -> Dictionary:
	var args = .get_exit_args()
	args["external"]["velocity"].y /= 3
	args["target_direction"].x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int 
	return args

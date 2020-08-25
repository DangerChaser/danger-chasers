extends MotionState
class_name AirState

export var up_animation := "jump_loop"
export var fall_animation : String = "air"

onready var ceiling_collision_particles : ParticleSpawner = $CeilingCollisionParticles

enum State { UP, FALL }
var state


var animation_set_externally := false


func enter(args := {}) -> void:
	.enter(args)
	steering.velocity.y = 0
	external.velocity.y /= 3
	gravity.speed = 0
	gravity.velocity.y = 0
	total_velocity = steering.velocity + gravity.velocity + external.velocity
	
	if total_velocity.y < 0:
		change_state(State.UP)
	else:
		change_state(State.FALL)
	
	if args.has("animation"):
		owner.play_animation(args["animation"])


func change_state(new_state) -> void:
	state = new_state
	if state == State.UP:
		owner.play_animation(up_animation)
	else:
		owner.play_animation(fall_animation)


func exit() -> void:
	.exit()


func _process(delta):
	if total_velocity.y < 0:
		change_state(State.UP)
	else:
		change_state(State.FALL)


func _physics_process(delta : float) -> void:
	if owner.is_on_ceiling():
		gravity.speed = abs(gravity.speed)
		external.velocity.y = 0.0
		
		var collision = owner.get_slide_collision(0)
		ceiling_collision_particles.global_position = collision.position
		ceiling_collision_particles.play()
	
	var direction = Vector2(get_input_direction().x, 0.0)
	move(direction)
	
	if owner.is_on_wall():
		steering.velocity.x = 0
	
	if owner.is_on_floor():
		finished("Idle", {"velocity":steering.velocity, "gravity_speed": gravity.speed, "initial_animation":"land"})
	
	if owner.state_machine.has_state("Stomp") and Input.is_action_just_pressed("ui_down"):
		var args = { "velocity": steering.velocity }
		args["input_key"] = "ui_down"
		args["target_direction"] = Vector2(steering.velocity.x, Vector2.DOWN.y) 
		finished("Stomp", args)


func take_damage(args := {}):
	finished("Stagger", args)

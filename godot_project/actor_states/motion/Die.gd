extends MotionState
class_name DieState

signal died

onready var die_particles := $DieParticles

export var animation : String = "die"
export var queue_free_on_die := true
export var distance_multiplier : float = 3.0
export var die_particles_scene : PackedScene

const QUEUE_FREE_BUFFER := 5.0


func _ready():
	die_particles.object_spawner.object = die_particles_scene


func enter(args := {}) -> void:
	.enter()
	emit_signal("entered")
	
	owner.play_animation(animation)
	var direction : Vector2
	if args.has("direction"):
		direction = args["direction"]
		if args.has("force") and args.has("mass") and args.has("duration"):
			initialize(args["direction"], args["force"], args["mass"], args["duration"])
	die_particles.spawn(owner.global_position, owner.global_rotation, owner.global_scale, owner.get_parent(), direction)
	emit_signal("died")


func anim_finished(anim_name : String) -> void:
	owner.emit_signal("died", owner)
	if queue_free_on_die:
		owner.call_deferred("queue_free")


func initialize(direction : Vector2, force : float, initial_mass : int, duration : float) -> void:
	force *= distance_multiplier
	external.velocity = direction * force
	external.apply(direction, force, initial_mass)
#	owner.set_rotation(direction.angle())

#extends MirrorBody2D
extends KinematicBody2D
class_name Projectile

signal team_set

export var initial_speed := 400
export var pierces_all_enemies := false
export var max_enemies_pierced := 1
export var destroy_particles : PackedScene
export var collision_particles : PackedScene
export var homing := false

onready var pivot : Pivot = $Pivot
onready var collider := $CollisionBox
onready var motion : MotionState = $Motion
onready var target := $Target
onready var startup_timer : Timer = $StartupDelay

var target_direction : Vector2
var velocity : Vector2
var confirmed_hits : int = 0
var paused := false
var friendly_teams : Array


func _ready() -> void:
	set_physics_process(false)
	target_direction = Vector2.RIGHT.rotated(get_rotation())
	motion.steering.velocity = target_direction * initial_speed
	
	pivot.connect("animation_finished", self, "_on_animation_finished")
	
	pivot.play("spawn")
	
	if (startup_timer.wait_time <= 0.01):
		start()
	else:
		startup_timer.start()


func _physics_process(delta : float) -> void:
	if get_slide_count() > 0: # Should only collide with Obstacles layer
		var particles = destroy()
		if particles:
			particles.start(global_position, \
 					motion.steering.velocity.angle() + PI, \
					global_scale.abs(), \
					get_parent())
	
	var target_object = $Target.get_target()
	if homing and target_object:
		target_direction = global_position.direction_to(target_object.global_position)
	
	motion.move(target_direction)
	
	motion.rotate_to_move_direction()


func set_friendly_teams(friendly_teams : Array) -> void:
	self.friendly_teams = friendly_teams
	if (has_node("DamageSource")):
		$DamageSource.friendly_teams = friendly_teams
	emit_signal("team_set", friendly_teams)


func _on_hit_confirmed(actor) -> void:
	confirmed_hits += 1
	var particles = spawn_particles(collision_particles)
	if particles:
		particles.start(global_position, \
		 				motion.steering.velocity.angle() + PI, \
						global_scale.abs(), \
						get_parent())
	
	if pierces_all_enemies:
		return
	if confirmed_hits >= max_enemies_pierced:
		yield(get_tree(), "physics_frame")
		particles = destroy()
		if particles:
			particles.start(global_position, \
		 				motion.steering.velocity.angle() + PI, \
						global_scale.abs(), \
						get_parent())


func destroy() -> SfxParticle:
	set_physics_process(false)
	pivot.play("destroy")
	if has_node("DamageSource"):
		$DamageSource.disable()
	return spawn_particles(destroy_particles)


func spawn_particles(particles_scene : PackedScene):
	if not particles_scene:
		return
	var new_particles = particles_scene.instance()
	return new_particles


func _on_animation_finished(anim_name : String) -> void:
	if anim_name == "spawn":
		pivot.play("motion")
	if anim_name == "destroy":
		queue_free()


func _on_StartupDelay_timeout():
	start()


func start() -> void:
	motion.enter()
	pivot.play("motion")
	set_physics_process(true)
	
	$Target.lock_on()

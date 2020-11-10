extends MirrorBody2D
class_name Projectile

export var initial_speed := 400
export var pierces_all_enemies := false
export var max_enemies_pierced := 1
export var destroy_particles : PackedScene
export var collision_particles : PackedScene

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
	target_direction = Vector2.RIGHT.rotated(get_rotation())
	
	if $AnimationPlayer.has_animation("spawn"):
		$AnimationPlayer.play("spawn")
	
	if (startup_timer.wait_time <= 0.01):
		start()
	else:
		startup_timer.start()


func _physics_process(delta : float) -> void:
	var target_object = $Target.get_target()
	if target_object:
		motion.move_to(target_object.global_position)
		return
	
	motion.move(target_direction)
	
	rotate_to_move_direction()
	
	if get_slide_count() > 0: # Should only collide with Obstacles layer
		destroy()


func rotate_to_move_direction() -> void:
	set_rotation(motion.total_velocity.angle())


func set_friendly_teams(friendly_teams : Array) -> void:
	if (has_node("DamageSource")):
		self.friendly_teams = friendly_teams
		$DamageSource.friendly_teams = friendly_teams


func _on_hit_confirmed(actor) -> void:
	confirmed_hits += 1
	spawn_particles(collision_particles)
	
	if pierces_all_enemies:
		return
	if confirmed_hits >= max_enemies_pierced:
		destroy()


func destroy() -> void:
	$AnimationPlayer.play("destroy")
	set_physics_process(false)
	$DamageSource.queue_free()
	spawn_particles(destroy_particles)


func spawn_particles(particles_scene : PackedScene):
	if not particles_scene:
		return
	var new_particles = particles_scene.instance()
	var particles_angle = motion.steering.velocity.angle() + PI
	new_particles.start(global_position, particles_angle, global_scale.abs(), get_parent())
	return new_particles


func _on_animation_finished(anim_name : String) -> void:
	if anim_name == "spawn":
		if $AnimationPlayer.has_animation("motion"):
			$AnimationPlayer.play("motion")
	if anim_name == "destroy":
		queue_free()

func _on_StartupDelay_timeout():
	start()


func start() -> void:
	motion.steering.velocity = target_direction * initial_speed
	motion.enter()
	if not $AnimationPlayer.current_animation == "spawn" and $AnimationPlayer.has_animation("motion"):
		$AnimationPlayer.play("motion")
	set_physics_process(true)

extends Node2D

onready var collider_shape : CollisionShape2D = $DamageSource/CollisionShape2D
onready var damage_tick_timer : Timer = $DamageTick
onready var damage_source = $DamageSource

export var ray_cast_collide := false
export var ray_cast_line_2d_scene : PackedScene
export var laser_start_particles_scene : PackedScene
export var laser_end_particles_scene : PackedScene
export var local_coordinates := true
var laser_start_particles : SfxParticle
var laser_end_particles : SfxParticle
var ray_cast_line : RayCastLine2D

var damage_source_enabled := false
var length : float
var hitbox_buffer_size := 6.0 # Ensures characters actually get hit

var original_position
var original_global_position


func _ready() -> void:
	original_position = position
	original_global_position = global_position
	
	_set_damage_source(false)
	assert(ray_cast_line_2d_scene)
	ray_cast_line = ray_cast_line_2d_scene.instance()
	add_child(ray_cast_line)
	ray_cast_line.disable()
	ray_cast_line.ray_cast_collide = ray_cast_collide
	
	if laser_start_particles_scene:
		var particles = laser_start_particles_scene.instance()
		laser_start_particles = particles if particles is SfxParticle else laser_start_particles
		laser_start_particles.position = ray_cast_line.position
		add_child(laser_start_particles)
		laser_start_particles.stop()
	if laser_end_particles_scene:
		var particles = laser_end_particles_scene.instance()
		laser_end_particles = particles if particles is SfxParticle else laser_end_particles
		add_child(laser_end_particles)
		laser_end_particles.stop()
	
	_set_damage_source(false)
	
	set_physics_process(false)


func enable() -> void:
	if not local_coordinates:
		position = original_position
		original_global_position = global_position
	
	ray_cast_line.enable()
	_laser_cast()
	
	_set_damage_source(true)
	
	damage_tick_timer.start()
	
	set_physics_process(true)
	
	if laser_start_particles:
		laser_start_particles.start()
	if laser_end_particles:
		laser_end_particles.start()


func disable() -> void:
	ray_cast_line.disable()
	_set_damage_source(false)
	
	damage_tick_timer.stop()
	if laser_start_particles:
		laser_start_particles.stop()
	if laser_end_particles:
		laser_end_particles.stop()


func _physics_process(delta):
	if not local_coordinates:
		global_position = original_global_position
	_laser_cast()


func _laser_cast() -> void:
	collider_shape.shape.length = ray_cast_line.length + hitbox_buffer_size
	if laser_end_particles:
		laser_end_particles.position = ray_cast_line.line.points[1]


func _on_DamageTick_timeout():
	_toggle_damage_source()


func _toggle_damage_source() -> void:
	if damage_source_enabled:
		_set_damage_source(false)
		if damage_tick_timer.one_shot:
			ray_cast_line.disable()
	else:
		_set_damage_source(true)


func _set_damage_source(value : bool) -> void:
	damage_source_enabled = value
	if value == true:
		damage_source.enable()
	else:
		damage_source.disable()

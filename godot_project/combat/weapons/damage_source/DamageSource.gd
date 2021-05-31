"""
Class for creating hitboxes that damage actors
"""
extends Area2D
class_name DamageSource

signal hit_confirmed(hit_actor_position)
signal hit_confirmed_hurtbox(hurtbox)
signal hit_confirmed_actor(hit_actor)
signal hit_confirmed_no_actor
signal attack_connected(parameters)

export var hit_particles : PackedScene
export var damage : int = 0
# var effect : StatusEffect = StatusEffect.new()
export var hitstun_duration := 0.1
export var stagger_duration := 0.5
export var stagger_mass := 8.0
export var stagger_force := 200.0
export var delay_milliseconds : int = 0
export var screen_shake_amplitude := 0.0
export var screen_shake_duration := 0.0
export(float, EASE) var screen_shake_damp := 1.8
export var stagger_direction_while_right := Vector2()
export var revenge_value := 1.0
export var track_hit_hurtboxes := true

onready var collider : CollisionShape2D = $CollisionShape2D
onready var hit_particles_spawner : ParticleSpawner = $HitParticlesSpawner

var friendly_teams := []
var confirmed_hits = 0
var hit_hurtboxes := []


func _ready() -> void:
	assert ($CollisionShape2D.shape != null)
	if not hit_particles_spawner.particles:
		hit_particles_spawner.particles = hit_particles


#func set_owner(new_owner) -> void:
#	owner = new_owner
#	if owner.has_method("get_friendly_teams"):
#		friendly_teams = owner.get_friendly_teams()


func add_damage(additional_damage : int = 0) -> void:
	damage += additional_damage


func confirm_hit(actor, hurtbox : Hurtbox) -> void:
	var parameters = {
		"actor" : actor,
		"hurtbox" : hurtbox
	}
	emit_signal("attack_connected", parameters)
	emit_signal("hit_confirmed", actor.global_position)
	emit_signal("hit_confirmed_actor", actor)
	emit_signal("hit_confirmed_hurtbox", hurtbox)
	emit_signal("hit_confirmed_no_actor")
	FrameFreeze.request(delay_milliseconds)
	shake_screen()
	hit_particles_spawner.spawn((collider.global_position + hurtbox.collider.global_position) / 2)
	confirmed_hits += 1
	if track_hit_hurtboxes:
		hit_hurtboxes.append(hurtbox)


func shake_screen() -> void:
	GameManager.current_camera.request_shake(screen_shake_amplitude, screen_shake_duration, screen_shake_damp)


func set_active(value : bool) -> void:
	for collider in get_children():
		collider.set_deferred("disabled", not value)

func enable() -> void:
	set_active(true)
	hit_hurtboxes = []

func disable() -> void:
	set_active(false)
	hit_hurtboxes = []


func _on_DamageSource_area_entered(area):
	if area is Hurtbox:
		area.take_damage(self)

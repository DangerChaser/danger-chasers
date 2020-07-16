"""
Class for creating hitboxes that damage actors
"""
extends Area2D
class_name DamageSource

signal hit_confirmed(hit_actor_position)
signal hit_confirmed_hurtbox(hurtbox)
signal hit_confirmed_actor(hit_actor)
signal hit_confirmed_no_actor

export(int) var damage : int = 0
# var effect : StatusEffect = StatusEffect.new()
export(float) var stagger_duration : float = 0.5
export var stagger_mass := 8.0
export var stagger_force := 800.0
export(int) var delay_milliseconds : int = 0
export(float) var screen_shake_amplitude : float = 0.0
export(float) var screen_shake_duration : float = 0.0
export(float, EASE) var screen_shake_damp : float = 1.8
export(Vector2) var stagger_direction_while_right := Vector2()
export var revenge_value := 1.0

onready var collider : CollisionShape2D = $CollisionShape2D

var friendly_teams : Array = []
var confirmed_hits = 0


func _ready() -> void:
	assert ($CollisionShape2D.shape != null)
	assert (damage != 0)


func add_damage(additional_damage : int = 0) -> void:
	damage += additional_damage


func confirm_hit(actor, hurtbox : Hurtbox) -> void:
	emit_signal("hit_confirmed", actor.global_position)
	emit_signal("hit_confirmed_actor", actor)
	emit_signal("hit_confirmed_hurtbox", hurtbox)
	emit_signal("hit_confirmed_no_actor")
	FrameFreeze.request(delay_milliseconds)
	shake_screen()


func shake_screen() -> void:
	GameManager.current_camera.request_shake(screen_shake_amplitude, screen_shake_duration, screen_shake_damp)


func set_active(value : bool) -> void:
	for collider in get_children():
		collider.set_deferred("disabled", not value)

func enable() -> void:
	set_active(true)

func disable() -> void:
	set_active(false)

"""
Hurtbox refers to the area that can be damaged.
Contrast with hitbox, which is the area that damages opponents
"""
extends Area2D
class_name Hurtbox

signal taken_damage

onready var collider := $CollisionShape2D

func _ready() -> void:
	assert (collider.shape != null)


func set_active(value : bool) -> void:
	collider.set_deferred("disabled", not value)

func enable() -> void:
	set_active(true)

func disable() -> void:
	set_active(false)


func take_damage(damage_source):
	emit_signal("taken_damage", damage_source, self)

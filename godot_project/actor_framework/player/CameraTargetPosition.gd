extends Node2D

export var offset : float = 100


func _physics_process(delta):
	global_position = owner.global_position + Vector2.RIGHT.rotated(owner.get_rotation()) * offset

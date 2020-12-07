extends Area2D


func _on_DropThroughArea_body_exited(body):
	if body == owner:
		return
	stop_drop_through()


func stop_drop_through() -> void:
	owner.set_collision_mask_bit(Utilities.Layers.DROP_THROUGH, true)

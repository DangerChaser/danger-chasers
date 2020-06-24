extends Node2D

signal camera_limits_set(limits, tween_time)

func _ready() -> void:
	for child in get_children():
		assert(child is Area2D)
		child.monitorable = false
		child.monitoring = true
		child.connect("camera_limits_set", self, "_on_camera_limit_area_entered")


func _on_camera_limit_area_entered(limits : Dictionary, tween_time : float) -> void:
	emit_signal("camera_limits_set", limits, tween_time)

extends Node2D


onready var moving_platforms : Node2D = $MovingPlatforms
onready var tween : Tween = $Tween

export(float) var time_to_move_one_floor : float = 3.0


func move(from : int, to: int) -> void:
	var from_platform = moving_platforms.get_child(from)
	var to_platform = moving_platforms.get_child(to)
	for platform in moving_platforms.get_children():
		if platform == from_platform:
			continue
		platform.disable()
	
	tween.connect("tween_completed", self, "_on_tween_completed", [from_platform.global_position])
	tween.interpolate_property(from_platform, "global_position", \
			from_platform.global_position, to_platform.global_position, \
			abs(to - from) * time_to_move_one_floor, \
			Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()


func _on_tween_completed(object: Object, key: NodePath, original_position : Vector2) -> void:
	tween.stop_all()
	tween.disconnect("tween_completed", self, "_on_tween_completed")
	for platform in moving_platforms.get_children():
		platform.enable()
	
	object.get_node("CollisionShape2D").disabled = true
	yield(get_tree().create_timer(0.01), "timeout")
	object.global_position = original_position
	yield(get_tree().create_timer(0.01), "timeout")
	object.get_node("CollisionShape2D").disabled = false

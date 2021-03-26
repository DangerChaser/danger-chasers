extends Area2D

class_name LevelTransition

signal player_entered(map, spawn_point, transition_in_texture, transition_in_duration)

export(String) var map_path : String
export(int) var spawn_point : int = 0
export(String) var transition_in_animation : String
export(float) var transition_in_duration := 0.5

func _ready() -> void:
	assert(map_path)

func _on_body_entered(body) -> void:
	if not body.is_in_group("players"):
		return
	change()

func change() -> void:
	GameManager.level.request_change(map_path, spawn_point, transition_in_animation, transition_in_duration)
	#emit_signal("player_entered", map_path, spawn_point, transition_in_animation, transition_in_duration)

func enable(value=null) -> void:
	if value:
		$CollisionShape2D.disabled = not value
	else:
		$CollisionShape2D.disabled = false

func disable() -> void:
	$CollisionShape2D.disabled = true

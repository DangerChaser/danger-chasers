extends Node2D

export(float) var offset : float = 100
export(float) var min_zoom := 0.9
export(float) var max_zoom := 1.1
export(float) var max_distance := 2000
export(float) var arrive_distance := 6.0

var target_zoom = Vector2(1, 1)

func _ready() -> void:
	assert(owner is Actor)

func _physics_process(delta):
	var camera = GameManager.current_camera
	if not camera.state == camera.States.NORMAL:
		return
	
	var target = owner.target.get_target()
	if target:
		var target_position = (target.global_position - owner.global_position) / 2 + owner.global_position
		if global_position.distance_to(target_position) < arrive_distance:
			return
		
		global_position = lerp(global_position,target_position, 0.1)
		
		var distance = owner.global_position.distance_to(global_position)
		var target_zoom = lerp(min_zoom, max_zoom, distance / max_distance)
		target_zoom = clamp(target_zoom, min_zoom, max_zoom)
		camera.change_target_zoom(Vector2(target_zoom, target_zoom))
		return
	
	var target_position = owner.global_position + Vector2.RIGHT.rotated(owner.get_rotation()) * offset
	global_position = lerp(global_position,target_position, 0.1)

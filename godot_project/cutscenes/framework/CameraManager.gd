extends Node2D


var current_camera


func enable(camera : int) -> void:
	if current_camera:
		current_camera.disable()
	current_camera = get_child(camera)
	current_camera.enable()


func disable(camera : int) -> void:
	if not current_camera:
		return
	get_child(camera).disable()
	current_camera = null


func disable_current_camera() -> void:
	if current_camera:
		current_camera.disable()

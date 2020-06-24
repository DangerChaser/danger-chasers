extends Node


func request_shake(_amplitude := -1.0, _duration := -1.0, _damp := -1.0) -> void:
	GameManager.current_camera.request_shake(_amplitude, _duration, _damp)

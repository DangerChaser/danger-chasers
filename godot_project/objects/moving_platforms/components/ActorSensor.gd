extends Area2D

export(String) var actor_name : String


signal triggered


func _physics_process(delta) -> void:
	var bodies = get_overlapping_bodies()
	for body in bodies:
		if body is Actor or body is PlayerActor:
			if actor_name and body.name != actor_name:
				return
			if body.is_on_floor():
				emit_signal("triggered")
				set_physics_process(false) # Disable checking
				return

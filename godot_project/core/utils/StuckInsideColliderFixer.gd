extends Node2D


func _physics_process(delta):
	if not $DownRaycast.is_colliding() or not $DownRaycast2.is_colliding() or not $UpRaycast.is_colliding() or not $UpRaycast2.is_colliding():
		return
	
	# Push owner up
#	owner.move_and_slide(Vector2.UP * 200)

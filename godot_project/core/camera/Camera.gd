extends KinematicBody2D


func _ready():
	$Motion.enter()


func _process(delta):
	if GameManager.players.size() > 0:
		$Motion.move_to(GameManager.get_player().get_node("CameraTargetPosition").global_position)


func disable() -> void:
	set_process(false)


func enable() -> void:
	set_process(true)

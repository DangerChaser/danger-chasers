extends Node
class_name PlayerDiedScript


func start(player=null) -> void:
	PlayerManager.player = null
	yield(get_tree().create_timer(1.0), "timeout")
	GameManager.game.level_loader.restart()

extends InteractableScript


export(String) var level_path : String
export(int) var spawn_point : int = 0

var interacted_actor

func interact(actor) -> void:
	interacted_actor = actor
	.interact(interacted_actor)
	$QuestBoardUI.enable()
	PlayerManager.disable_input()


func _on_QuestBoardUI_disabled():
	PlayerManager.enable_input()

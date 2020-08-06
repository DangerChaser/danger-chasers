extends InteractableScript


export(String) var level_path : String
export(int) var spawn_point : int = 0

var interacted_actor

func interact(actor) -> void:
	interacted_actor = actor
	.interact(interacted_actor)
	$QuestBoardUI.enable()
	interacted_actor.state_machine.change_state("Cutscene")


func _on_QuestBoardUI_disabled():
	interacted_actor.state_machine.initialize()

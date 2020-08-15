extends Cutscene


func _ready() -> void:
	for i in range($Dialogues.get_child_count()):
		var dialogue_starter : DialogueStarter = $Dialogues.get_child(i)
		dialogue_starter.connect("finished", self, "_on_dialogue_finished", [i])


func _on_dialogue_finished(dialogue_number : int) -> void:
	if dialogue_number + 1 >= $Dialogues.get_child_count():
		end()
	else:
		next()

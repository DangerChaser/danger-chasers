extends Cutscene

signal dialogue_list_exhausted

export(Array, String) var json_names := [""]
var times_interacted := 0


func start() -> void:
	if times_interacted >= json_names.size():
		$DialogueInteraction.json_name = json_names[json_names.size() - 1]
		emit_signal("dialogue_list_exhausted")
	else:
		$DialogueInteraction.json_name = json_names[times_interacted]
		times_interacted += 1
		.start()
	if has_node("NPC"):
		$NPC.face_actor()


func _on_dialogue_ended():
	end()

extends Node
class_name DialogueStarter

signal finished

export var json_name := ""

func start() -> void:
	var json_path = "res://dialogue/"
	json_path += json_name
	Dialogue.start_dialogue(json_path, self)
	Dialogue.connect("dialogue_ended", self, "_on_Dialogue_ended")


func _on_Dialogue_ended() -> void:
	Dialogue.disconnect("dialogue_ended", self, "_on_Dialogue_ended")
	emit_signal("finished")

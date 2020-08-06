extends Node2D

signal dialogue_ended

export var json_name := ""

func start(icon : Texture = null,json_override : String = "") -> void:
	var json_path = "res://dialogue/"
	if json_override:
		json_path += json_override
	else:
		json_path += json_name
	Dialogue.start_dialogue(json_path, self)
	Dialogue.Box.icon_node.texture = icon
	Dialogue.connect("dialogue_ended", self, "_on_Dialogue_ended")


func _on_InteractionArea_interacted():
	start()


func _on_Dialogue_ended() -> void:
	Dialogue.disconnect("dialogue_ended", self, "_on_Dialogue_ended")
	emit_signal("dialogue_ended")

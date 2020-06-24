extends Node2D

export(String) var json_name := ""

func start(icon : Texture = null,json_override : String = "") -> void:
	var json_path = "res://dialogue/"
	if json_override:
		json_path += json_override
	else:
		json_path += json_name
	Dialogue.start_dialogue(json_path, self)
	Dialogue.Box.icon_node.texture = icon


func _on_InteractionArea_interacted():
	start()

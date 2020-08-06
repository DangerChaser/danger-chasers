tool
extends EditorPlugin


func _enter_tree():
	add_autoload_singleton("Dialogue", "res://addons/radmatt.DialogueSystem2/Dialogue.tscn")


func _exit_tree():
	remove_autoload_singleton("Dialogue")

extends Node

export var elevator : NodePath

func move(from : int, to : int) -> void:
	get_node(elevator).move(from, to)

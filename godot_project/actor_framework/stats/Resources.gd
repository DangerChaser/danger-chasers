extends Node2D

var dictionary : Dictionary

func _ready():
	for child in get_children():
		dictionary[child.name] = child

extends Control

export(PackedScene) var input_line

func clear():
	for child in get_children():
		child.free()

func add_input_line(action_name, key, is_customizable=false):
	var line = input_line.instance()
	line.initialize(action_name, key, is_customizable)
	add_child(line)
	return line

extends Label

signal finished

export var delay : float = 0.05
export var last_delay : float = 0.2
export var sfx : AudioStream


func display(name):
	show()
	text = name
	visible_characters = 0
	for i in name.length():
		yield(get_tree().create_timer(delay), "timeout")
		visible_characters += 1
	yield(get_tree().create_timer(last_delay), "timeout")
	emit_signal("finished")
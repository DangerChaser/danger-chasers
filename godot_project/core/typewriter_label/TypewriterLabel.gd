extends Label
class_name TypewriterLabel

signal finished

func print_string(string, delay=0.02):
	visible_characters = 0
	text = string
	visible = true
	for character in string:
		visible_characters += 1
		$SFX.play()
		yield(get_tree().create_timer(delay), "timeout")
	emit_signal("finished")


func print_key(category:String, key:String, delay:float=0.02):
	self.print_string(Language.get_text(category, key), delay)
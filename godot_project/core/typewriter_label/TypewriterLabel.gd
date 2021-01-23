extends KeyLabel
class_name TypewriterLabel

export var sfx : AudioStream

signal finished


func _ready() -> void:
	$SFX.stream = sfx
	visible_characters = 0


func print_key(key:String, delay:float=0.02):
	set_key(key)
	print_string(delay)

func print_string(delay := 0.02):
	visible_characters = 0
	visible = true
	for character in text:
		visible_characters += 1
		$SFX.play()
		yield(get_tree().create_timer(delay), "timeout")
	emit_signal("finished")

func hide() -> void:
	visible = false

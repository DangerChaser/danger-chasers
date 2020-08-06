extends RichTextLabel
class_name KeyRichTextLabel

export(String) var key : String = ""

func _ready() -> void:
	set_key(key)

func set_key(new_key : String) -> void:
	if new_key:
		bbcode_text = tr(new_key)

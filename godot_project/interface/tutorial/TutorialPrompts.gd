extends CanvasLayer

var current_prompt

func show(key : String) -> void:
	if current_prompt:
		current_prompt.hide()
	current_prompt = get_node("Prompts/" + key)
	get_node("Prompts/" + key).show()

func hide(key : String = "") -> void:
	if key:
		get_node("Prompts/" + key).hide()
	else:
		if current_prompt:
			current_prompt.hide()
	current_prompt = null

extends Button


export var always_enabled := false


func enable() -> void:
	disabled = false


func disable() -> void:
	if not always_enabled:
		disabled = true

extends HBoxContainer
class_name Bar


onready var texture_progress : TextureProgress = $Overlay/TextureProgress


func set_bar(new_value : float, old_value : float, max_value : float) -> void:
	texture_progress.max_value = max_value
	texture_progress.value = new_value

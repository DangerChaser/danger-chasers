extends Cutscene

onready var experience_bar := $CanvasLayer/Control2/ExperienceBar

func _ready() -> void:
	experience_bar.initialize(PlayerManager.current_level)

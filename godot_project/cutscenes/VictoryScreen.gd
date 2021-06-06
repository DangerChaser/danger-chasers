extends Cutscene

onready var experience_bar := $CanvasLayer/LevelUpScreen/ExperienceBar
onready var loot_screen := $CanvasLayer/LootScreen

export var items : Dictionary

func _ready() -> void:
	experience_bar.initialize(PlayerManager.current_level)


func start_loot_screen() -> void:
	loot_screen.initialize(items)

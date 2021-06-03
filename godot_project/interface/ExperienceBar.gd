extends Control

onready var current_level_label : KeyLabel = $CurrentLevel/KeyLabel
onready var next_level_label : KeyLabel = $NextLevel/KeyLabel

var current_level


func initialize(current_level : int) -> void:
	self.current_level = current_level
	current_level_label.set_key(str(current_level))
	next_level_label.set_key(str(current_level + 1))

func start() -> void:
	$AnimationPlayer.play("start")


func set_labels_to_next_level() -> void:
	current_level += 1
	current_level_label.set_key(str(current_level))
	next_level_label.set_key(str(current_level + 1))

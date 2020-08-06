extends Button
class_name QuestNameButton

var quest

onready var name_label := $NameLabel

func initialize(target_quest : Quest) -> void:
	quest = target_quest
	name_label.set_key(quest.quest_name_key)

extends CanvasLayer

export var quest_name_button : PackedScene

signal disabled

onready var control := $Control
onready var quest_name_container := $Control/HBoxContainer/QuestListContainer/ScrollContainer/VBoxContainer
onready var quest_description_name_label := $Control/HBoxContainer/QuestDescriptionContainer/VBoxContainer/QuestNameLabel
onready var quest_description_label := $Control/HBoxContainer/QuestDescriptionContainer/VBoxContainer/QuestDescriptionLabel
onready var decline_button := $Control/HBoxContainer/QuestDescriptionContainer/VBoxContainer/HBoxContainer/DeclineButton
onready var accept_button := $Control/HBoxContainer/QuestDescriptionContainer/VBoxContainer/HBoxContainer/AcceptButton

export var spawn_point : int = 0
export var transition_in_animation : String
export var transition_in_duration : float

var current_quest_name_button : QuestNameButton
var accepted : bool

func _ready():
	control.visible = false


func enable() -> void:
	accepted = false
	
	for quest in QuestManager.get_active_quests():
		var new_quest_name_button = quest_name_button.instance()
		quest_name_container.add_child(new_quest_name_button)
		new_quest_name_button.initialize(quest)
		new_quest_name_button.connect("button_down", self, "_on_quest_name_button_down", [new_quest_name_button])
	current_quest_name_button = quest_name_container.get_child(0)
	var quest = current_quest_name_button.quest
	quest_description_name_label.set_key(quest.quest_name_key)
	quest_description_label.set_key(quest.quest_description_key)
	current_quest_name_button.grab_focus()
	control.visible = true
	
	set_process_input(true)


func disable() -> void:
	for quest in quest_name_container.get_children():
		quest.queue_free()
	control.visible = false
	emit_signal("disabled")
	set_process_input(false)


func _input(event) -> void:
	if event.is_action_pressed("pause"):
		disable()

func _on_quest_name_button_down(quest_name_button : QuestNameButton) -> void:
	current_quest_name_button = quest_name_button
	
	var quest = current_quest_name_button.quest
	quest_description_name_label.set_key(quest.quest_name_key)
	quest_description_label.set_key(quest.quest_description_key)
	accept_button.grab_focus()


func _on_DeclineButton_button_down():
	current_quest_name_button.grab_focus()


func _on_AcceptButton_button_down():
	if accepted:
		return
	accepted = true
	var quest = current_quest_name_button.quest
	GameManager.level.request_change(quest.level_path, spawn_point, transition_in_animation, transition_in_duration)


func _on_BackButton_button_down():
	disable()

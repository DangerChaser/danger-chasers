extends Control

onready var states_Label = $StatesPanel/StatesLabel
onready var stats_label = $StatsPanel/StatsLabel
onready var health_bar : HealthBar = $HealthBar
onready var revenge_bar : Bar = $RevengeBar

onready var original_offset : Vector2 = rect_position

export var show := false

var target


func _ready() -> void:
	set_process(false)


func initialize() -> void:
	target = owner
	health_bar.initialize(target)
	
	var target_parent = target.get_parent()
	get_parent().remove_child(self)
	target_parent.add_child(self)
	set_process(true)
	
	if show:
		visible = true


func _process(delta):
	if not is_instance_valid(target):
		queue_free()
		return
	if target.get_parent():
		rect_global_position = target.global_position + original_offset


func _on_Stats_stats_changed(new_stats : CharacterStats) -> void:
	stats_label.update_label(new_stats)


func _on_StateMachine_state_changed(states : Array) -> void:
	states_Label.update_label(states)


func revenge_updated(revenge_value, old_revenge_value, revenge_threshold) -> void:
	revenge_bar.set_bar(revenge_value, old_revenge_value, revenge_threshold)

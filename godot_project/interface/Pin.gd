extends Control

var target
onready var pin_offset : Vector2 = rect_position


func _ready():
	set_process(false)

func enable(target, text) -> void:
	self.target = target
	get_parent().remove_child(self)
	GameManager.level.y_sort.add_child(self)
	rect_scale = Vector2(1, 1) / get_parent().scale
	set_process(true)
	
	get_node("KeyLabel").text = text
	visible = true


func _process(delta) -> void:
	rect_global_position = target.global_position + pin_offset


func disable() -> void:
	visible = false
	set_process(false)

extends Control

var target
onready var pin_offset : Vector2 = rect_position


func _ready():
	disable()

func enable(target, text) -> void:
	if text == "light_attack":
		text = InputMap.get_action_list("light_attack")[0].as_text()
	
	get_node("KeyLabel").text = text
	visible = true
	
	if not target:
		return
	self.target = target
	get_parent().remove_child(self)
	GameManager.level.y_sort.add_child(self)
	rect_scale = Vector2(1, 1) / get_parent().scale
	set_process(true)


func _process(delta) -> void:
	if target:
		rect_global_position = target.global_position + pin_offset


func disable() -> void:
	visible = false
	set_process(false)

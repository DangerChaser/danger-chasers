extends Node2D

export var mark_rate := 0.02

onready var marks := $Marks
onready var timer := Timer.new()

var original_transform : Transform2D
var original_local_transform : Transform2D
var marks_enabled := 0


func _ready() -> void:
	for mark in $Marks.get_children():
		mark.get_node("Sprite").visible = false
	original_local_transform = transform
	_add_timer()


func _add_timer() -> void:
	timer.wait_time = mark_rate
	timer.connect("timeout", self, "_on_Timer_timeout")
	add_child(timer)


func _on_Timer_timeout() -> void:
	if marks_enabled >= marks.get_child_count():
		disable()
		return
	var mark = $Marks.get_child(marks_enabled)
	mark.get_node("AnimationPlayer").play("start")
	marks_enabled += 1


func start() -> void:
	marks_enabled = 0
	timer.start()
	enable()


func _physics_process(delta):
	global_transform = original_transform


func enable() -> void:
	transform = original_local_transform
	original_transform = global_transform


func disable() -> void:
	timer.stop()


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		disable()

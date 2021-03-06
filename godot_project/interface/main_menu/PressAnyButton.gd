extends Control

signal finished

onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	set_process_input(false)


func start() -> void:
	visible = true
	animation_player.play("start")


func _input(event : InputEvent) -> void:
	if event.is_pressed():
		finish()


func finish() -> void:
	set_process_input(false)
	emit_signal("finished")


func transition_out() -> void:
	animation_player.play("transition_out")


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	if old_name == "start":
		set_process_input(true)

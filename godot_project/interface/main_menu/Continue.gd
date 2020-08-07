extends Control

signal back_selected

onready var animation_player : AnimationPlayer = $AnimationPlayer

var game_path := "res://core/Game.tscn"


func _on_BackButton_button_down():
	emit_signal("back_selected")


func start():
	animation_player.play("start")
	visible = true
	yield(get_tree().create_timer(animation_player.current_animation_length), "timeout")
	$BackButton.grab_focus()


func transition_out():
	animation_player.play("transition_out")

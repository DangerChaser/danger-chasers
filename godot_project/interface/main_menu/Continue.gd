extends Control

signal back_selected

onready var animation_player : AnimationPlayer = $AnimationPlayer

var game_path := "res://core/Game.tscn"


func start():
	animation_player.play("start")
	visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	$BackButton.grab_focus()


func transition_out():
	animation_player.play("transition_out")


func _on_YesButton_pressed():
	animation_player.play("finished")
	yield(get_tree().create_timer(animation_player.current_animation_length), "timeout")
	get_tree().change_scene(game_path)


func _on_BackButton_pressed():
	emit_signal("back_selected")

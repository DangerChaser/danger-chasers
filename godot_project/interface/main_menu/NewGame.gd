extends Control

signal no_selected

onready var animation_player : AnimationPlayer = $AnimationPlayer

var game_path := "res://core/Game.tscn"

func _on_Yes_button_down():
	animation_player.play("finished")
	yield(get_tree().create_timer(animation_player.current_animation_length), "timeout")
	get_tree().change_scene(game_path)


func _on_No_button_down():
	emit_signal("no_selected")


func start():
	animation_player.play("start")
	visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	$YesButton.grab_focus()


func transition_out():
	animation_player.play("transition_out")

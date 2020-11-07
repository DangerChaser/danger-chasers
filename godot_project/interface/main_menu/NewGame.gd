extends Control

signal no_selected

onready var animation_player : AnimationPlayer = $AnimationPlayer
export var new_game_scene : PackedScene

var game_path := "res://core/Game.tscn"


func start():
	animation_player.play("start")
	visible = true
	yield(get_tree().create_timer(0.1), "timeout")
	$VBoxContainer/YesButton.grab_focus()


func transition_out():
	animation_player.play("transition_out")


func _on_YesButton_pressed():
	animation_player.play("finished")
	yield(get_tree().create_timer(animation_player.current_animation_length), "timeout")
	GameManager.current_loaded_level = new_game_scene
	get_tree().change_scene(game_path)

func _on_NoButton_pressed():
	emit_signal("no_selected")

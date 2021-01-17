extends Control

onready var animation_player : AnimationPlayer = $AnimationPlayer


func _ready() -> void:
	animation_player.play("SETUP")

func show() -> void:
	animation_player.play("show")

func hide() -> void:
	animation_player.play_backwards("show")

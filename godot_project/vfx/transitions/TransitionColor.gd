extends ColorRect

class_name TransitionColor

signal transition_finished

onready var anim_player : AnimationPlayer = $AnimationPlayer

func _ready():
	anim_player.play("SETUP")

func fade_to_color():
	visible = true
	anim_player.play("to_color")
	yield(anim_player, "animation_finished")

func fade_from_color():
	anim_player.play("from_color")
	yield(anim_player, "animation_finished")
	visible = false
	emit_signal("transition_finished")

extends Node2D
class_name Cutscene

signal finished

onready var animation_player : AnimationPlayer = $AnimationPlayer
var scene_index := 0

func _ready() -> void:
	play("SETUP")

func start() -> void:
	if GameManager.DEBUG_MODE:
		end()
		return
	play("0")

func end():
	play("end")

func next() -> void:
	scene_index += 1
	play(str(scene_index))

func play(var name : String ="", var custom_blend : float =-1, var custom_speed : float = 1.0, var from_end : bool = false ) -> void:
	CutsceneManager.current_cutscene = self
	animation_player.play(name, custom_blend, custom_speed, from_end)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "end":
		emit_signal("finished")

func show_player_hud() -> void:
	PlayerManager.show_player_hud()

func hide_player_hud() -> void:
	PlayerManager.hide_player_hud()

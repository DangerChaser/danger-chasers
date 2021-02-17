extends Node2D
class_name Cutscene

signal finished

export var auto_start := false

onready var animation_player : AnimationPlayer = $AnimationPlayer
var scene_index := 0

func _ready() -> void:
	if not auto_start:
		play("SETUP")
	else:
		start()

func start() -> void:
#	if GameManager.DEBUG_MODE:
#		end()
#		return
	if GameManager.game:
		GameManager.game.pause_menu.can_pause = false
	play("0")
	set_process_input(true)

func end():
	if GameManager.game:
		GameManager.game.pause_menu.can_pause = true
	play("end")

func next() -> void:
	scene_index += 1
	play(str(scene_index))

func play(var name : String ="", var custom_blend : float =-1, var custom_speed : float = 1.0, var from_end : bool = false ) -> void:
	animation_player.play(name, custom_blend, custom_speed, from_end)

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "end":
		emit_signal("finished")
		set_process_input(false)
		if GameManager.game:
			GameManager.game.pause_menu.can_pause = true
	else:
		scene_index += 1

func show_player_hud() -> void:
	PlayerManager.show_player_hud()

func hide_player_hud() -> void:
	PlayerManager.hide_player_hud()


func _input(event):
	if event.is_action_pressed("ui_cancel"):
		$SkipCutsceneFade/AnimationPlayer.play("fade_in")


func _on_SkipCutsceneAnimationPlayer_finished(anim_name):
	if anim_name == "fade_in":
		$SkipCutsceneFade/AnimationPlayer.play("fade_out")
		end()

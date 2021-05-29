extends Node2D
class_name Cutscene

signal started
signal end_started
signal finished

export var auto_start := false
export var replayable := true
export var skippable := true

onready var animation_player : AnimationPlayer = $AnimationPlayer
var scene_index := 0

func _ready() -> void:
	if not replayable:
		var data = GameManager.load_data()
		if data.has(name + "seen") and data[name + "seen"]:
			queue_free()
			return
	
	if auto_start:
		start()
	
	set_process_input(false)

func start() -> void:
	if GameManager.game:
		GameManager.game.pause_menu.can_pause = false
	play("0")
	set_process_input(true)
	emit_signal("started")

func end():
	if GameManager.game:
		GameManager.game.pause_menu.can_pause = true
	GameManager.save(name + "seen", true)
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
		if skippable:
			$SkipCutsceneFade/AnimationPlayer.play("fade_in")


func _on_SkipCutsceneAnimationPlayer_finished(anim_name):
	if anim_name == "fade_in":
		$SkipCutsceneFade/AnimationPlayer.play("fade_out")
		end()


func _on_AnimationPlayer_animation_started(anim_name):
	if anim_name == "end":
		emit_signal("end_started")

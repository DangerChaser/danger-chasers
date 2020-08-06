extends Node2D
class_name Cutscene

signal ended

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var player_cutscene_manager : PlayerCutsceneManager = $PlayerCutsceneManager


func _ready() -> void:
	play("SETUP")

func start() -> void:
	CutsceneManager.current_cutscene = self
	play("start")

func play(var name : String ="", var custom_blend : float =-1, var custom_speed : float = 1.0, var from_end : bool = false ) -> void:
	CutsceneManager.current_cutscene = self
	animation_player.play(name, custom_blend, custom_speed, from_end)

func enable() -> void:
	player_cutscene_manager.enable()


func disable() -> void:
	end()
	player_cutscene_manager.disable()


func start_from_actor_death(actor) -> void:
	start()


func end():
	play("end")
	emit_signal("ended")


func next_dialogue(box_icon : Texture = null) -> void:
	set_dialogue_icon(box_icon)
	Dialogue.set_next(Dialogue.get_dialogue_node_by_id(Dialogue.current_id).next)
	Dialogue.next()


func set_dialogue_icon(texture : Texture) -> void:
	Dialogue.get_node("BoxMessage/TextBackground/_hbox/Face").texture = texture


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "end":
		player_cutscene_manager.disable()

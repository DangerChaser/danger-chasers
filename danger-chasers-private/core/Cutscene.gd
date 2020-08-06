extends Node2D
class_name Cutscene

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var player_cutscene_manager : PlayerCutsceneManager = $PlayerCutsceneManager


func _ready() -> void:
	play("SETUP")

func start() -> void:
	CutsceneManager.current_cutscene = self
	if not Dialogue.is_connected("dialogue_ended", self, "end"):
		Dialogue.connect("dialogue_ended", self, "end")
	play("start")

func play(var name : String ="", var custom_blend : float =-1, var custom_speed : float = 1.0, var from_end : bool = false ) -> void:
	CutsceneManager.current_cutscene = self
	animation_player.play(name, custom_blend, custom_speed, from_end)

func enable() -> void:
	player_cutscene_manager.enable()


func disable() -> void:
	play("end")
	player_cutscene_manager.disable()


func start_from_actor_death(actor) -> void:
	start()


func end():
	Dialogue.disconnect("dialogue_ended", self, "end")
	play("end")


func _on_CollisionTrigger_area_entered(area):
	start()


func _on_InteractionArea_interacted_with_actor(actor):
	start()


func next_dialogue(box_icon : Texture = null) -> void:
	Dialogue.set_next(Dialogue.get_dialogue_node_by_id(Dialogue.current_id).next)
	Dialogue.next()
	set_dialogue_icon(box_icon)


func set_dialogue_icon(texture : Texture) -> void:
	Dialogue.get_node("BoxMessage/TextBackground/_hbox/Face").texture = texture


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "end":
		player_cutscene_manager.disable()

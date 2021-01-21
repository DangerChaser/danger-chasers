extends Node2D
class_name Pivot

signal animation_started(anim_name)
signal animation_finished(anim_name)
signal animation_changed(old_name, new_name)
signal animation_play_requested(old_name, new_name)

export(Array, NodePath) var sub_pivot_transforms : Array

onready var animation_player : AnimationPlayer = $AnimationPlayer
var old_animation : String = ""

func _ready() -> void:
	if not animation_player.is_connected("animation_finished", self, "_on_AnimationPlayer_animation_finished"):
		animation_player.connect("animation_finished", self, "_on_AnimationPlayer_animation_finished")
	if not animation_player.is_connected("animation_changed", self, "_on_AnimationPlayer_animation_changed"):
		animation_player.connect("animation_changed", self, "_on_AnimationPlayer_animation_changed")

func play(name="", custom_blend:=-1.0, custom_speed:=1.0, from_end:=false):
	if animation_player.has_animation(name):
		var old_name = animation_player.current_animation
		if old_name == name:
			pass
#			animation_player.stop()
		else:
			emit_signal("animation_play_requested", old_name, name)
		animation_player.play(name, custom_blend, custom_speed, from_end)
		emit_signal("animation_started", name)
	for pivot_transform_node_path in sub_pivot_transforms:
		var pivot_transform = get_node(pivot_transform_node_path)
		if pivot_transform.has_node("Pivot") and pivot_transform.pivot.has_animation(name):
			pivot_transform.play(name, custom_blend, custom_speed, from_end)
		else:
			pivot_transform.play("SETUP", custom_blend, custom_speed, from_end)


func has_animation(name : String) -> bool:
	return animation_player.has_animation(name)


func _on_AnimationPlayer_animation_finished(anim_name):
	emit_signal("animation_finished", anim_name)


func _on_AnimationPlayer_animation_changed(old_name, new_name):
	emit_signal("animation_changed", old_name, new_name)

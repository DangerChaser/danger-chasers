extends AnimationPlayer
class_name ActorWithWeaponAnimationPlayer

export(Array, PackedScene) var extra_animation_layers
export(Array, PackedScene) var extra_animation_layers_behind
var extra_layers : Array

func _ready() -> void:
	for layer in  extra_animation_layers:
		var new_layer = layer.instance()
		extra_layers.append(new_layer)
		get_parent().call_deferred("add_child", new_layer)
		call_deferred("set_all_children_owner", get_parent(), get_parent().owner)
	for layer in  extra_animation_layers_behind:
		var new_layer = layer.instance()
		extra_layers.append(new_layer)
		get_parent().call_deferred("add_child", new_layer)
		get_parent().call_deferred("move_child", new_layer, 0)
		call_deferred("set_all_children_owner", get_parent(), get_parent().owner)

func play(name="", custom_blend:=-1.0, custom_speed:=1.0, from_end:=false):
	if has_animation(name):
		.play(name, custom_blend, custom_speed, from_end)
	for layer in extra_layers:
		var anim_player = layer.get_node("AnimationPlayer")
		if anim_player.has_animation(name):
			anim_player.stop()
			anim_player.play(name)


func set_all_children_owner(parent, _owner) -> void:
	for child in parent.get_children():
		child.owner = _owner
		if child.get_child_count() > 0:
			set_all_children_owner(child, _owner)

# TODO: Legacy code, delete eventually
extends AnimationPlayer
class_name ActorWithWeaponAnimationPlayer


func play(name="", custom_blend:=-1.0, custom_speed:=1.0, from_end:=false):
	if has_animation(name):
		.play(name, custom_blend, custom_speed, from_end)
	else:
		.play("", custom_blend, custom_speed, from_end)


func set_all_children_owner(parent, _owner) -> void:
	for child in parent.get_children():
		child.owner = _owner
		if child.get_child_count() > 0:
			set_all_children_owner(child, _owner)

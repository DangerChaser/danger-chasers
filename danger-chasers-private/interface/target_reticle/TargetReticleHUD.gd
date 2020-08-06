extends Control
class_name TargetReticleHUD

export(PackedScene) var target_reticle : PackedScene

var current_target_reticle : TargetReticle
var current_target_reticle_wr : WeakRef


func _on_target_acquired(new_target) -> void:
	disable()
	if not new_target:
		return
	current_target_reticle = target_reticle.instance()
	current_target_reticle_wr = weakref(current_target_reticle)
	GameManager.level.y_sort.call_deferred("add_child", current_target_reticle)
	current_target_reticle.initialize(new_target)
	current_target_reticle.enable()


func disable() -> void:
	if current_target_reticle and current_target_reticle_wr.get_ref():
		current_target_reticle.disable()
		current_target_reticle = null
		current_target_reticle_wr = null
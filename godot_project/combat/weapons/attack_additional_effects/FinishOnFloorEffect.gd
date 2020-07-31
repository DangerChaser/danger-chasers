extends AttackAdditionalEffect
class_name FinishOnFloorEffect


func enter(args := {}) -> void:
	yield(get_tree().create_timer(0.01), "timeout")
	.enter(args)


func _physics_process(delta:float) -> void:
	if owner.is_on_floor():
		emit_signal("finished")

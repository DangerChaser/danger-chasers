extends AttackAdditionalEffect
class_name FinishOnFloorEffect


func _physics_process(delta:float) -> void:
	if owner.is_on_floor():
		emit_signal("finished")

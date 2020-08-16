extends AttackAdditionalEffect


onready var attacks := get_parent().get_parent().get_parent()

func _physics_process(delta:float) -> void:
	if owner.is_on_floor():
		attacks.attack()

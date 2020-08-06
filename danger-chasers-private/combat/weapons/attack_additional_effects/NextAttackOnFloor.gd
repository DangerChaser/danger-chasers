extends AttackAdditionalEffect


onready var attacks := get_parent().get_parent().get_parent()

func _physics_process(delta:float) -> void:
	if owner.is_on_floor():
		attacks.register_attack()
		attacks.enable_ready_for_next_attack()
		attacks.attack_if_ready()

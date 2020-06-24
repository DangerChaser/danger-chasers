extends AttackAdditionalEffect
class_name PlayAnimationEffect

export(String) var actor_animation := ""

func play() -> void:
	owner.animation_player.play(actor_animation)

extends AnimationPlayer

func play(var name : String ="", var custom_blend : float =-1, var custom_speed : float = 1.0, var from_end : bool = false ) -> void:
	.play(name, custom_blend, custom_speed, from_end)

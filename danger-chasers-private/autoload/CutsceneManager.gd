extends Node

var current_cutscene


func play(var name : String ="", var custom_blend : float =-1, var custom_speed : float = 1.0, var from_end : bool = false ) -> void:
	assert(current_cutscene)
	current_cutscene.animation_player.play(name, custom_blend, custom_speed, from_end)

func play_and_hide_dialogue(var name : String ="", var custom_blend : float =-1, var custom_speed : float = 1.0, var from_end : bool = false ) -> void:
	play(name, custom_blend, custom_speed, from_end)
	#Dialogue.Bubble.disable()
	#Dialogue.Box.disable()


func end() -> void:
	play("end")

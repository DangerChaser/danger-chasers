extends CanvasLayer

signal transition_in_finished
signal transition_out_finished

onready var in_animation_player : AnimationPlayer = $TransitionShader/TransitionInAnimationPlayer
onready var out_animation_player : AnimationPlayer = $TransitionShader/TransitionOutAnimationPlayer

enum State { IDLE, TRANSITIONING_IN, TRANSITIONING_OUT }
var state = State.IDLE

var transition_out_animation : String



func transition_in(animation:String, duration := 0.5, out_animation:String=""):
	if out_animation:
		transition_out_animation = out_animation
	in_animation_player.playback_speed = 1.0 / duration
	if in_animation_player.has_animation(animation):
		in_animation_player.play(animation)
	else:
		in_animation_player.play("left_to_right")
	state = State.TRANSITIONING_IN
	return self # For yield calls

func transition_out(animation:String="", duration := 0.5):
	if transition_out_animation:
		animation = transition_out_animation
	out_animation_player.playback_speed = 1.0 / duration
	if animation:
		if out_animation_player.has_animation(animation):
			out_animation_player.play(animation)
		else:
			out_animation_player.play("left_to_right")
	state = State.TRANSITIONING_OUT
	return self # For yield calls


func _on_TransitionInAnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_in_finished")


func _on_TransitionOutAnimationPlayer_animation_finished(anim_name):
	emit_signal("transition_out_finished")

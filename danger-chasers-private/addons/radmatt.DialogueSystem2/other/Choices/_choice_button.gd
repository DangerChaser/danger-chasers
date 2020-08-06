extends Button
class_name ChoiceButton, "res://addons/radmatt.DialogueSystem2/icons/ChoiceButton.svg"

export (AudioStreamSample) var focus_sound
export (AudioStreamSample) var select_sound


func _ready():
	connect("focus_entered", self, "_choice_button_focused")
	connect("pressed", self, "_choice_button_pressed")


# When player selects a button
func _choice_button_focused():
	_play_sound(focus_sound)


# When player presses a button
func _choice_button_pressed():
	_play_sound(select_sound)
	Dialogue.choice_made(get_index())
	Dialogue.Box.Choices.deactivate()
	Dialogue.Bubble.Choices.deactivate()


func _play_sound(sfx):
	if sfx != null:
		$sound.stream = sfx
		$sound.play()
	else:
		push_warning("No choice button sound selected")

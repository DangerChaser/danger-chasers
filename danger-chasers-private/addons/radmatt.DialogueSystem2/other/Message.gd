
extends Control
class_name Message, "res://addons/radmatt.DialogueSystem2/icons/Message.svg"

###############################################################################
# Settings:

export (NodePath) var text_path
export (NodePath) var choices_path
export (NodePath) var icon_path

export var text_speed = 0.01 # Text speed
export var sound_effect_speed = 0.1 # Sound effect frequency

export var bubble_y_offset = -48 # Bubble only
export var bubble_max_width = 700 # Bubble only


##############################
# SIGNALS
signal started_new_message
signal finished_message

##############################
# NODES:
onready var sound = $SoundEffect
onready var text_node = get_node(text_path)
onready var Choices = get_node(choices_path)
onready var icon_node = get_node(icon_path)


##############################
# VARIABLES:
var wait_for_choice = false
var is_message_completed = false
var current_character = 0 # Current letter in a text
var characters_left = []

var raw_text = "" # may include bbcode
var clean_text = "" # does not include bbcode


###############################################################################
### FUNCTIONS ###
###############################################################################

func _ready():
	hide()

# SET ITS SIZE TO MATCH THE TEXT
func _process(delta):
	Dialogue.Box.get_node("TextBackground").margin_top = 0


func show_new_message(text, wait_for_choice=false): # Message initiation

	if wait_for_choice:
		Dialogue.can_continue = false
	is_message_completed = false
	text_node.clear()
	text_node.text = text
	Dialogue.message_finished = false
	if ! Dialogue.current_choices_array.empty():
		Dialogue.is_waiting_for_decision = true
	else:
		Dialogue.is_waiting_for_decision = false

	emit_signal("started_new_message")
	_start_showing_characters()
	_start_playing_sound()
	show()


func finish_message(): # If pressed [dialogue_next] button while the text was appearing >>> jump to the end.
	is_message_completed = true
	text_node.show_all_characters()
	Dialogue.message_finished = true
	if ! Dialogue.current_choices_array.empty():
		Choices.activate()
	else:
		pass

	emit_signal("finished_message")




func _start_showing_characters():
	for x in text_node.clean_text.length()+1:
		if ! is_message_completed:
			text_node.visible_characters += 1
			yield(get_tree().create_timer(text_speed), "timeout")
		else:
			break
	finish_message()



func _start_playing_sound():
	while true:
		if ! is_message_completed:
			sound.play()
			yield(get_tree().create_timer(sound_effect_speed), "timeout")
		else:
			break


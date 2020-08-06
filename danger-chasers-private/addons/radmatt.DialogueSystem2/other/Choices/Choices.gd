
extends Control
class_name Choices, "res://addons/radmatt.DialogueSystem2/icons/Choices.svg"
###############################################################################


export (NodePath) var choices_container
export (PackedScene) var choice_button


func _ready():
	choices_container = get_node(choices_container) # Turn path (string) into a node.
	hide()
	reset()


func activate():
	show()
	choices_container.get_child(0).grab_focus() # Make the first choice button active

func deactivate():
	hide()


func reset():
	for x in choices_container.get_children():
		x.queue_free()


###############################################################################
# MANAGING CHOICE BUTTONS

func add_choice_buttons():
	for choice in Dialogue.current_choices_array:
		if choice["is_condition"]:
			if Dialogue.evaluate_value(choice["condition"]):
				create_button(choice)
			else:
				var button = create_button(choice)
				button.disabled = true
				button.hint_tooltip = "Condition not met: " + str(choice["condition"])
		else:
			create_button(choice)


func create_button(choice_data):
	var button = choice_button.instance()
	button.set_text(choice_data.text[Dialogue.language])

	choices_container.add_child(button)

	return button




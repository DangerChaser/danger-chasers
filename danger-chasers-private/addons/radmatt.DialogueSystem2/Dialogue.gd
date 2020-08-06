
"""
LICENSE:
Copyright 2020 (C) by radmatt / radmattsoftware@gmail.com
Do not tell people that you made this. Do not re-sell or share this code.
You can use it in your commercial projects. Please don't use this code in open-source projects.
Having a right to sell this code helps me develop high quality software
and frameworks for everyone to enjoy. Thanks!
"""

extends CanvasLayer

###############################################################################
# Settings:
###############################################################################

export (String, "ENG", "PL") var language = "ENG"

export (String, "2D", "3D") var perspective = "2D"

export (String, "Auto", "Bubble", "Box") var selected_type = "Auto"

export var dialogue_next_input = "dialogue_next"

##############################
# SIGNALS:

signal dialogue_started
signal dialogue_ended

##############################
# NODES:

onready var Box = $BoxMessage
onready var Bubble = $BubbleMessage
var current_message_type

##############################
# VARIABLES:

# Setting which dialogue node will be next (doesn't have to be a message node)
var next = null setget set_next
func set_next(new_next):
	next = new_next

# Camera used for 3D Bubble postioning:
onready var camera = get_node("/root/").find_node("Camera", true, false)

var json_data = {}
var current_id = null # current dialogue node's id
var interacted_character = null
var current_speaker_node = null
var current_speaker_name = ""
var repeats = {}
var message_finished = false
var is_waiting_for_decision = false
var current_choices_array = []
var current_json_path = ""


##############################
# LOCAL DIALOGUE VARIABLES MANAGEMENT

var local = {} # Stores local variables from the editor

func set_var(var_name, value):
	local[current_json_path][var_name]["value"] = value

func get_var(var_name):
	return local[current_json_path][var_name]["value"]


###############################################################################
### FUNCTIONS ###
###############################################################################

func _ready():
	set_process(false)


# UPDATE BUBBLE MESSAGE'S POSITION
func _process(delta):
	if current_speaker_node != null:

		if perspective == "2D":
			var pos = current_speaker_node.get_global_transform_with_canvas().origin
			Bubble.set_global_position(pos + Vector2(0, Bubble.bubble_y_offset))


		elif perspective == "3D":
			var pos = current_speaker_node.global_transform.origin
			var screenPos = camera.unproject_position(pos)
			Bubble.set_position(screenPos + Vector2(0, Bubble.bubble_y_offset))



####################################
### PARSING JSON ###

func load_data(json_path):
	var file = File.new()
	file.open(json_path, File.READ)
	json_data = parse_json(file.get_as_text())
	file.close()


func get_dialogue_node_by_id(id):
	for node in json_data[0]["nodes"]:
		if node["node_name"] == id:
			return node


func find_start():
	for node in json_data[0]["nodes"]:
		if node["node_type"] == "start":
			return node



##########################################
### MESSAGE SYSTEM

# Start dialogue
func start_dialogue(json_path, interacted_object=null):
	current_json_path = json_path
	load_data(json_path)

	interacted_character = interacted_object
	is_waiting_for_decision = false
	message_finished = true

	# set up local_variables
	local[current_json_path] = json_data[0]["variables"]

	set_process(true)
	emit_signal("dialogue_started")
	set_next(find_start().next)
	_auto_next()



func _auto_next(): # Automaticaly goes to the next dialogue node
	next()

# Complete the message / Go to next dialogue node
func next():
	if ! message_finished: # Is the message showing all of the text? If not, show all text and exit script.
		current_message_type.finish_message()
		return

	elif ! is_waiting_for_decision: # There are no choices to make and you can just continue the dialogue?
		current_id = next

		if next == null: # If this dialogue node doesn't point to any other,
			end()         # that means it's the end of the dialogue.
			return

		Bubble.hide()
		Box.hide()
		# If everything above is ok, then execute functions (see 'NODE TYPES FUNCTIONS' section).
		var this = get_dialogue_node_by_id(next)

		match this.node_type:

			"show_message":
				show_message(this)

			"set_local_variable":
				set_local_variable(this)

			"condition_branch":
				condition_branch(this)

			"repeat":
				repeat(this)

			"chance_branch":
				chance_branch(this)

			"random_branch":
				random_branch(this)

			"wait":
				wait(this)

			"execute":
				execute(this)


# When player pressed a choice button
func choice_made(idx):
	for choice in Box.Choices.choices_container.get_children():
		choice.queue_free()

	for choice in Bubble.Choices.choices_container.get_children():
		choice.queue_free()

	set_next(get_dialogue_node_by_id(current_id).choices[idx]["next"])
	is_waiting_for_decision = false
	current_choices_array.clear()
	_auto_next()



# End the dialogue
func end():
	Bubble.hide()
	Box.hide()
	current_speaker_node = null
	current_choices_array = []
	current_id = null
	current_json_path = ""
	emit_signal("dialogue_ended")
	set_process(false)


###############################################################################
# NODE TYPES FUNCTIONS
###############################################################################

func show_message(current_node):

	current_message_type = get_message_type(current_node)

	# CHOOSING CURRENT SPEAKER NODE
	if current_node.speaker_type == 0: # A specified node name
		current_speaker_node = get_node("/root/").find_node(current_node.character[0], true, false)
		current_speaker_name = current_node.character[0]
	elif current_node.speaker_type == 1: # A custom path
		current_speaker_node = get_node(evaluate_value(current_node.object_path))
	else: # A node passed through a parameter (in the 'start_dialogue' function)
		current_speaker_node = interacted_character

	# REPLACING VARIABLE NAMES WITH VALUES
	var final_text = current_node.text[language]
	while final_text.find("@") != -1: # does it have at least one call for variable?
		var p = final_text.find("@")
		var s = final_text.find("@", p+1)
		var part = final_text.substr(p, s-p+1)
		var ev = final_text.substr(p+1, s-p-1)
		final_text = final_text.replace(part, str(evaluate_value(ev)))

	# IF THERE ARE ANY CHOICES, SHOW THEM
	if current_node.has("choices"):
		current_choices_array = current_node.choices.duplicate(true)
		current_message_type.Choices.add_choice_buttons()
	else:
		set_next(current_node.next)

	# IF FINALLY, SHOW A MESSAGE
	current_message_type.show_new_message(final_text)


func set_local_variable(current_node):
	if json_data[0]["variables"][current_node.var_name]["type"] == 0:
		set_var(current_node.var_name, current_node.value)
	elif json_data[0]["variables"][current_node.var_name]["type"] == 1:
		set_var(current_node.var_name, current_node.value)
	elif json_data[0]["variables"][current_node.var_name]["type"] == 2:
		if current_node.toggle:
			set_var(current_node.var_name, !get_var(current_node.var_name))
		else:
			set_var(current_node.var_name, current_node.value)

	set_next(current_node.next)
	_auto_next()



func execute(current_node):
	execute_code(current_node.text)
	set_next(current_node.next)
	_auto_next()



func condition_branch(current_node):
	var c = current_node.text
	if evaluate_value(c):
		set_next(current_node["branches"]["True"])
	else:
		set_next(current_node["branches"]["False"])
	_auto_next()



func repeat(current_node):
	if repeats.has(current_node.node_name):
		if repeats[current_node.node_name] > 0:
			repeats[current_node.node_name] = repeats[current_node.node_name] - 1
			set_next(current_node.next)
		else:
			set_next(current_node.next_done)
			repeats.erase(current_node.node_name)
		_auto_next()
	else:
		repeats[current_node.node_name] = current_node.value
		repeats[current_node.node_name] = repeats[current_node.node_name] - 1
		set_next(current_node.next)
		_auto_next()



func wait(current_node):
	Bubble.hide()
	Box.hide()
	var duration = current_node.time
	if duration > 0:
		yield(get_tree().create_timer(duration), "timeout")
		set_next(current_node.next)
		_auto_next()



func chance_branch(current_node):
	if chance(current_node.chance_1):
		set_next(current_node["branches"]["1"])
	else:
		set_next(current_node["branches"]["2"])
	_auto_next()



func random_branch(current_node):
	var random = random(int(current_node.possibilities))
	set_next(current_node["branches"][str(random)])
	_auto_next()



###############################################################################
# OTHER
###############################################################################


# PRESS A BUTTON TO CONTINUE DIALOGUE
func _input(event):
	if (event.is_action_pressed("ui_accept") or event.is_action_pressed("ui_select") or event.is_action_pressed(dialogue_next_input)) and ! event.is_echo():
		if current_json_path != "":
			next()


# GET A RANDOM NUMBER
func random(possibilities):
	randomize()
	var r = randi() % possibilities + 1
	return r


# GET TRUE OR FALSE DEPENDING ON CHANCE
func chance(percent):
	randomize()
	var r = randi() % 100 + 1
	print("chance: " + str(r))
	if r <= percent:
		return true
	else:
		return false


# GET A VALUE AND RETURN IT
func evaluate_value(input):
	var script = GDScript.new()
	script.set_source_code("func eval():\n\treturn " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	return obj.eval()


# EXECUTE A FUNCTION
func execute_code(input):
	print_debug(input)
	var script = GDScript.new()
	script.set_source_code("func eval(): " + input)
	script.reload()
	var obj = Reference.new()
	obj.set_script(script)
	return obj.eval()


# CHECK IF WE SHOULD SHOW A BOX OR BUBBLE MESSAGE
func get_message_type(current_node):
	if selected_type == "Auto":
		if current_node.is_box:
			return Box
		else:
			return Bubble

	elif selected_type == "Box":
		return Box

	elif selected_type == "Bubble":
		return Bubble


extends Control
class_name Text, "res://addons/radmatt.DialogueSystem2/icons/Text.svg"
###############################################################################

export var autowrap = false setget set_autowrap

var text = "" setget set_text
var visible_characters = -1 setget set_visible_characters

onready var label = $Label
onready var richtext = $Label/RichTextLabel


var clean_text = ""

var text_elements = []

###############################################################################

func _ready():
	$Label.self_modulate = Color(1,1,1,0) # Hide the Label, we only use it for its position... sorry label :(
	$Label.autowrap = self.autowrap
	clear()

# Reset to default values
func clear():
	self.text_elements.clear()
	self.text = ""
	self.clean_text = ""
	self.visible_characters = -1


###############################################################################
# SET TEXT
###############################################################################

func set_text(new_text:String):
	text = new_text

	# First, set the clean text to Label to get the right margins:
	clean_text = parse_bbcode(text)
	label.text = clean_text
	# Then set the raw text as RichTextLabel's bbcode and hide all characters:
	richtext.bbcode_text = text
	richtext.visible_characters = -1


# Turn stylised text with bbcode tags, into clean text:
# For example: "[b]This[/b] is an [color:red]APPLE[/color]" into "This is an APPLE" #
func parse_bbcode(raw_text:String):
	richtext.bbcode_text = raw_text
	return richtext.text


func set_autowrap(true_or_false):
	autowrap = true_or_false
	$Label.autowrap = autowrap


###############################################################################
# SHOW TEXT
###############################################################################

func set_visible_characters(new_amount:int):
	visible_characters = new_amount
	label.visible_characters = visible_characters
	richtext.visible_characters = visible_characters

func show_all_characters():
	self.visible_characters = clean_text.length()+1

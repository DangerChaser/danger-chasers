
extends PanelContainer


onready var max_width = get_parent().bubble_max_width

func _ready():
	set_process(false)
	Dialogue.connect("dialogue_started", self, "_on_dialogue_started")
	Dialogue.connect("dialogue_ended", self, "_on_dialogue_ended")
	get_parent().connect("started_new_message", self, "_on_started_new_message")





# Resize the background to fit currently displayed text
func _on_started_new_message():
	$Text.autowrap = false
	self.margin_bottom = 0
	self.margin_right = 0
	self.margin_left = 0
	self.margin_top = 0

	yield(get_tree(), "idle_frame") # Wait for GUI to update

	if self.rect_size.x > max_width:
		$Text.autowrap = true
		self.margin_right = max_width / 2
		self.margin_left = -max_width / 2





# Make sure smallest it can be
func _process(delta):
	self.margin_top = 0


# When there is no dialogue, don't run the _process() (waste of resources)
func _on_dialogue_started():
	set_process(true)

func _on_dialogue_ended():
	set_process(false)




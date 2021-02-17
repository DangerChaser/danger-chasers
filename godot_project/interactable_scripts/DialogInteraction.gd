extends Node2D

signal dialogic_signal(value)

export(String, "TimelineDropdown") var timeline: String

onready var interaction_area : InteractionArea = $InteractionArea


func _ready() -> void:
	$CanvasLayer/DialogNode.connect("dialogic_signal", self, 'signal_from_dialogic')

func _on_InteractionArea_interacted():
	$CanvasLayer/DialogNode.timeline = timeline
	$CanvasLayer/DialogNode.initialize()
	
	$PlayerManagedStateManager.disable_input()
	$PlayerManagedStateManager.hide_player_hud()

func signal_from_dialogic(value):
	emit_signal("dialogic_signal", value)
	
	if value == "end":
		$PlayerManagedStateManager.enable_input()
		$PlayerManagedStateManager.show_player_hud()

func enable() -> void:
	interaction_area.enable()

func disable() -> void:
	interaction_area.disable()

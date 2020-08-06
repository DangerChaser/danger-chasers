extends Node2D

export(String) var state := ""

func _ready() -> void:
	assert state

func apply(actor : Actor) -> void:
	actor.state_machine.change_state(state)
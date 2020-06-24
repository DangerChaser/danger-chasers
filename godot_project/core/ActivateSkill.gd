extends Node2D

export(String) var skill := ''
export(int) var experience := -1

func apply(actor : Actor) -> void:
	activate()

func activate() -> void:
	PlayerManager.activate_skill(skill, experience)

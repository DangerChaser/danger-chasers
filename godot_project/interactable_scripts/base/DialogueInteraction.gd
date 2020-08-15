extends Node2D

signal dialogue_ended

onready var dialogue_starter : DialogueStarter = $DialogueStarter

func start() -> void:
	dialogue_starter.start()

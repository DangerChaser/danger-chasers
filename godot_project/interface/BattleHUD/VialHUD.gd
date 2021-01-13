extends Control

onready var progress : ProgressBar = $ProgressBar


func _ready():
	progress.value = progress.max_value
	$AnimationPlayer.play("SETUP")


func open():
	$AnimationPlayer.play("open")

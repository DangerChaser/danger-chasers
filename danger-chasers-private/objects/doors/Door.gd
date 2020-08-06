extends Node2D
class_name Door

var opened : bool = false

func _ready() -> void:
	close()

func interact() -> void:
	if opened:
		close()
	else:
		open()



func open() -> void:
	$AnimationPlayer.play("open")
	$OpenSfx.play()
	opened = true


func close() -> void:
	$AnimationPlayer.play("close")
	$CloseSfx.play()
	opened = false

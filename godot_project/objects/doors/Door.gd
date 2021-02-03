extends Node2D
class_name Door

export var opened : bool = false

func _ready() -> void:
	if opened:
		$StaticBody2D/CollisionShape2D.disabled = true
		$AnimationPlayer.play("open_loop")
	else:
		$StaticBody2D/CollisionShape2D.disabled = false
		$AnimationPlayer.play("close_loop")


func interact() -> void:
	if opened:
		close()
	else:
		open()



func open() -> void:
	$AnimationPlayer.play("open")
	opened = true


func close() -> void:
	$AnimationPlayer.play("close")
	opened = false


func assert_closed() -> void:
	$StaticBody2D/CollisionShape2D.disabled = false
	$AnimationPlayer.play("close_loop")


func assert_opened() -> void:
	$StaticBody2D/CollisionShape2D.disabled = true
	$AnimationPlayer.play("open_loop")

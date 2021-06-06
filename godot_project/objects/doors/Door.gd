tool
extends Node2D
class_name Door

export var opened : bool = false

func _draw() -> void:
	if not Engine.editor_hint:
		return
	if opened:
		assert_opened()
	else: 
		assert_closed() 


func _ready() -> void:
	if opened:
		assert_opened()
	else: 
		assert_closed() 


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
	if has_node("StaticBody2D/CollisionShape2D"):
		$StaticBody2D/CollisionShape2D.disabled = false
	if $AnimationPlayer.has_animation("close_loop"):
		$AnimationPlayer.play("close_loop")


func assert_opened() -> void:
	if has_node("StaticBody2D/CollisionShape2D"):
		$StaticBody2D/CollisionShape2D.disabled = false
	if $AnimationPlayer.has_animation("open_loop"):
		$AnimationPlayer.play("open_loop")

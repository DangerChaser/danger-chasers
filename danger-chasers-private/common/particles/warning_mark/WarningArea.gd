extends Node2D

onready var scanner : Area2D = $WarningMarkScanner
onready var marks := $Marks

var original_transform : Transform2D
var original_local_transform : Transform2D

func _ready() -> void:
	original_local_transform = transform
	for mark in marks.get_children():
		mark.get_node("CollisionTrigger").monitoring = false
	scanner.monitorable = false
	set_physics_process(false)


func start() -> void:
	$AnimationPlayer.play("start")
	enable()


func _physics_process(delta):
	global_transform = original_transform


func enable() -> void:
	transform = original_local_transform
	original_transform = global_transform
	set_physics_process(true)
	scanner.monitorable = true
	for mark in marks.get_children():
		mark.get_node("CollisionTrigger").monitoring = true


func disable() -> void:
	scanner.monitorable = false
	for mark in marks.get_children():
		mark.get_node("CollisionTrigger").monitoring = false


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "start":
		disable()

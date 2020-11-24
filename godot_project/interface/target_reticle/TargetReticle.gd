extends KinematicBody2D
class_name TargetReticle

export(float) var rotation_speed = 1.0 # Degrees per second

onready var pivot : Node2D = $Pivot
onready var sprite : Sprite = pivot.get_node("Sprite")
onready var motion : MotionState = $Motion
var target
var target_wr


func _ready():
	for child in motion.get_children():
		child.owner = self


func initialize(new_target) -> void:
	if not new_target:
		return
	target = new_target
	target_wr = weakref(new_target)
	global_position = target.global_position


func enable() -> void:
	set_physics_process(true)
	$AnimationPlayer.play("enable")
	$Sfx.play()


func disable() -> void:
	$AnimationPlayer.play("disable")
	set_physics_process(false)
	yield($AnimationPlayer, "animation_finished")
	queue_free()


func _physics_process(delta : float) -> void:
	pivot.global_rotation_degrees += rotation_speed
	pivot.global_rotation_degrees = fmod(pivot.global_rotation_degrees, 360)
	if target:
		if target_wr.get_ref():
			motion.move_to(target.global_position)
			return
		disable()

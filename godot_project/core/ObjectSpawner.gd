tool
extends Position2D
class_name ObjectSpawner

signal spawned(object)

onready var initializations := $Initializations

export var object : PackedScene
export var random_degrees : float = 0
export var random_radius : float = 0
export var DRAW_COLOR := Color("#1418ff")


func _draw() -> void:
	if not Engine.editor_hint:
		return
	var size := Vector2(64, 64)
	var rect := Rect2(-size / 2, size)
	draw_rect(rect, DRAW_COLOR, false)


func spawn(parent=null):
	if not object:
		return
	
	var new_object = object.instance()
	
	_set_position(new_object)
	
	_set_rotation(new_object)
	
	for function in initializations.get_children():
		function.initialize(new_object)
	
	emit_signal("spawned", new_object)
	
	if parent:
		parent.add_child(new_object)
	
	return new_object


func _set_position(object) -> void:
	var random_angle = randf() * 2 * PI
	var distance_from_center = randf() * self.random_radius
	var target_position = global_position + Vector2.RIGHT.rotated(random_angle) * distance_from_center
	object.global_position = target_position


func _set_rotation(object) -> void:
	object.rotation = global_rotation
	
	if random_degrees > 0:
		var random_degree_change = randi() % int(random_degrees) - random_degrees / 2
		object.rotation += deg2rad(random_degree_change)

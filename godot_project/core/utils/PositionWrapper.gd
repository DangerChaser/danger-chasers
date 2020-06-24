extends Area2D

export(bool) var wrap_x := true
export(bool) var wrap_y := true

onready var collider : CollisionShape2D = $CollisionShape2D
onready var shape := collider.shape

var affected_objects := []


func _ready() -> void:
	assert (shape is RectangleShape2D)
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")


func enable() -> void:
	$CollisionShape2D.set_deferred("disabled", false)


func disable() -> void:
	affected_objects.clear()
	$CollisionShape2D.set_deferred("disabled", true)

func _on_area_entered(area) -> void:
	add_object(area.owner)


func add_object(object) -> void:
	if not affected_objects.has(object):
		affected_objects.append(object)
		print(object.name)


func remove_object(object) -> void:
	if affected_objects.has(object):
		affected_objects.remove(object)


func _on_area_exited(area) -> void:
	var object = area.owner
	if not affected_objects.has(object):
		return
	
	if wrap_x:
		if object.global_position.x > collider.global_position.x + shape.extents.x:
			object.global_position.x = collider.global_position.x - shape.extents.x
			if object is PlayerActor:
				GameManager.current_camera.reset_smoothing()
		elif object.global_position.x > collider.global_position.x - shape.extents.x:
			object.global_position.x = collider.global_position.x + shape.extents.x
			if object is PlayerActor:
				GameManager.current_camera.reset_smoothing()
	if wrap_y:
		if object.global_position.y > collider.global_position.y + shape.extents.y:
			object.global_position.y = collider.global_position.y - shape.extents.y
			if object is PlayerActor:
				GameManager.current_camera.global_position = object.global_position
				GameManager.current_camera.reset_smoothing()
		elif object.global_position.y > collider.global_position.y - shape.extents.y:
			object.global_position.y = collider.global_position.y + shape.extents.y
			if object is PlayerActor:
				GameManager.current_camera.global_position = object.global_position
				GameManager.current_camera.reset_smoothing()

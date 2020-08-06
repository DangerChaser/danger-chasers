tool
extends Node2D

var _active_point_index := 0

func get_start_position() -> Vector2:
	return get_child(0).global_position


func get_current_point_position() -> Vector2:
	return get_child(_active_point_index).global_position


func get_next_point_position() -> Vector2:
	_active_point_index = (_active_point_index + 1) % get_child_count()
	return get_current_point_position()


func reset() -> void:
	_active_point_index = 0


#########################
## Editor drawing code ##
#########################
export var editor_process := true setget set_editor_process
export var line_color := Color("80aff2")
export var triangle_color := Color("ffffff")
export var line_width := 10.0


func _ready() -> void:
	if not Engine.editor_hint:
		set_process(false)


func _process(delta: float) -> void:
	update()


func _draw() -> void:
	if not Engine.editor_hint:
		return
	if not get_child_count() > 1:
		return
	
	var points := PoolVector2Array()
	var triangles := []
	var last_point := Vector2.ZERO
	
	for child in get_children():
		points.append(child.position)
		
		if points.size() > 1:
			var center : Vector2 = (child.position + last_point) / 2
			var angle := last_point.angle_to_point(child.position)
			triangles.append({center = center, angle = angle})
		
		last_point = child.position
	
	points.append(get_child(0).position)
	var center : Vector2 = (get_child(0).position + last_point) / 2
	var angle := last_point.angle_to_point(get_child(0).position)
	triangles.append({center = center, angle = angle})
	
	draw_polyline(points, line_color, line_width, true)
	for triangle in triangles:
		draw_triangle(triangle["center"], triangle["angle"], line_width * 2.0)


func draw_triangle(center:Vector2, angle:float, radius:float) -> void:
	var points := PoolVector2Array()
	var colors := PoolColorArray([triangle_color])
	
	for i in range(3):
		var angle_point := angle + i * 2.0 * PI / 3.0 + PI
		var offset := Vector2(radius * cos(angle_point), radius * sin(angle_point))
		var point := center + offset
		points.append(point)
	
	draw_polygon(points, colors)


func set_editor_process(value:bool) -> void:
	editor_process = value
	
	if not Engine.editor_hint:
		return
	set_process(value)

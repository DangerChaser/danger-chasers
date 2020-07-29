extends Line2D
class_name Trail

export(NodePath) var target_path
export(Array, String) var active_animations : Array = ["quick_attack"]
export(int) var trail_length := 10
export(bool) var autostart := true

var target
var point
var active := false


func _ready():
	target = get_node(target_path)
	if autostart:
		start()


func _process(delta):
	if not active:
		if get_point_count() > 0:
			remove_point(0)
		return
	
	global_position = Vector2()
	global_rotation = 0
	global_scale = Vector2(1, 1)
	point = target.global_position
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)


func start(animation : String = ""):
	if not animation in active_animations:
		return
	active = true


func stop(animation : String = ""):
	if not animation in active_animations:
		return
	active = false


func reset():
	while get_point_count() > 0:
		remove_point(0)

extends Line2D
class_name Trail

export var target_path : NodePath
export(Array, String) var active_animations : Array = []
export var trail_length := 10
export var autostart := true
export var trail_decay := 2 # How many points get erased per frame if not active

var target
var point
var active := false


func _ready():
	set_process(false)
	target = get_node(target_path)
	if autostart:
		start()


func _process(delta):
	global_position = Vector2()
	global_rotation = 0
	global_scale = Vector2(1, 1)
	
	if not active:
		for i in range(0, trail_decay):
			if get_point_count() > 0:
				remove_point(0)
			else:
				set_process(false)
				return
	
	point = target.global_position
	add_point(point)
	while get_point_count() > trail_length:
		remove_point(0)


func start(animation : String = ""):
	if active_animations.size() > 0 and not animation in active_animations:
		return
	active = true
	set_process(true)


# new_animation is a dummy variable for connecting to AnimationPlayer.animation_changed signal
func stop(animation : String = "", new_animation = "") -> void:
	if active_animations.size() > 0  and not animation in active_animations:
		return
	active = false


func reset():
	while get_point_count() > 0:
		remove_point(0)

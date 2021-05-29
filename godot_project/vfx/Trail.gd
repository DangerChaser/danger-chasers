extends Line2D
class_name Trail

export var target_path : NodePath
export(Array, String) var active_animations : Array = []
export var distance := 10
export var lifetime := 0.5

export var emit := true
export var segments := 40
var target

var trail_points := []
var offset := Vector2()
var point


class Point:
	var position := Vector2()
	var age       := 0.0

	func _init(position :Vector2, age :float) -> void:
		self.position = position
		self.age = age
	
	func update(delta :float, points :Array) -> void:
		self.age -= delta
		if self.age <= 0:
			points.erase(self)


func _ready():
	offset = position
	show_behind_parent = true
	clear_points()
	set_as_toplevel(true)
	position = Vector2()
	
	set_process(false)
	
	if target_path:
		target = get_node(target_path)
	else:
		target = get_parent()
	
	if emit:
		set_process(true)


func _process(delta):
	if not is_instance_valid(target):
		for point in trail_points:
			point.update(delta, trail_points)
		
		if trail_points.size() == 0:
			queue_free()
		return
	
	if emit:
		_emit()
	else:
		update_points()


func start(animation : String = ""):
	if active_animations.size() > 0 and not animation in active_animations:
		return
	emit = true
	set_process(true)


# new_animation is a dummy variable for connecting to AnimationPlayer.animation_changed signal
func stop(animation : String = "", new_animation = "") -> void:
	emit = false
	if active_animations.size() > 0  and not animation in active_animations:
		return


func reset():
	while get_point_count() > 0:
		remove_point(0)




func _emit():
	var _rotated_offset :Vector2 = offset.rotated(target.rotation)
	var _position :Vector2 = target.global_transform.origin + _rotated_offset
	var point = Point.new(_position, lifetime)
	
	if trail_points.size() < 1:
		trail_points.push_back(point)
		return
	
	if trail_points[-1].position.distance_squared_to(_position) > distance*distance:
		trail_points.push_back(point)
	
	update_points()


func update_points() -> void:
	var delta = get_process_delta_time()
		
	if trail_points.size() > segments:
		trail_points.invert()
		trail_points.resize(segments)
		trail_points.invert()
	
	clear_points()
	for point in trail_points:
		point.update(delta, trail_points)
		
#		if point:
		add_point(point.position)

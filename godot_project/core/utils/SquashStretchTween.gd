extends Tween

export var target_path : NodePath
export var horizontal_factor := 1.0
export var vertical_factor := 1.0
export var in_duration := 0.1
export var out_duration := 0.1

onready var target = get_node(target_path) if target_path else null
var original_scale : Vector2
var transition_out : bool


func _ready():
	if target:
		original_scale = target.scale

func set_owner(owner):
	.set_owner(owner)
	if not target and owner is Actor:
		target = owner.get_node("Pivot")
		original_scale = target.scale

func initialize(horizontal_factor = null, vertical_factor = null, in_duration = null, out_duration = null, target = null) -> void:
	if target:
		self.target = target 
		original_scale = target.scale
	if not self.target:
		self.target = owner
	if horizontal_factor:
		self.horizontal_factor = horizontal_factor
	if vertical_factor:
		self.vertical_factor = vertical_factor
	if in_duration:
		self.in_duration = in_duration
	if out_duration:
		self.out_duration = out_duration
	
	begin()

func begin() -> void:
	transition_out = true
	var factor = Vector2(horizontal_factor, vertical_factor)
	interpolate_property(target, "scale", target.scale, original_scale * factor, in_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
	start()


func _on_SquashStretchTween_tween_completed(object, key):
	if not transition_out:
		return
	
	if object == target and key == ":scale":
		transition_out = false
		var factor = Vector2(horizontal_factor, vertical_factor)
		interpolate_property(target, "scale", original_scale * factor, original_scale, out_duration, Tween.TRANS_QUAD, Tween.EASE_OUT)
		start()

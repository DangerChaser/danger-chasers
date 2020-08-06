extends Position2D

export var pivot_scene : PackedScene
var pivot

func _ready() -> void:
	initialize()

func initialize() -> void:
	if pivot_scene:
		pivot = pivot_scene.instance()
		add_child(pivot)

func play(name="", custom_blend:=-1.0, custom_speed:=1.0, from_end:=false):
	if pivot:
		pivot.play(name, custom_blend, custom_speed, from_end)

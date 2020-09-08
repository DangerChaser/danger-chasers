extends Position2D

var pivot

func _ready() -> void:
	if get_child_count() > 0:
		pivot = get_child(0)
		assert(pivot is Pivot)
#		pivot.target = get_path()


func play(name="", custom_blend:=-1.0, custom_speed:=1.0, from_end:=false):
	if pivot:
		pivot.play(name, custom_blend, custom_speed, from_end)

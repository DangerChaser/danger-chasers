extends VBoxContainer

export var reference_vial : PackedScene

var active_vial
var index := 0


func vial_initialized() -> void:
	var new_vial = reference_vial.instance()
	add_child(new_vial)


func open(max_value):
	if index >= get_child_count() or active_vial:
		return
	
	active_vial = get_child(index)
	
	active_vial.progress.max_value = max_value
	active_vial.progress.value = max_value
	
	index += 1


func tick(value):
	if not active_vial:
		return
	active_vial.progress.value -= value


func finished():
	active_vial = null

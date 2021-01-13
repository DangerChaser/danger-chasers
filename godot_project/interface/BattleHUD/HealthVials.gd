extends VBoxContainer

var active_vial
var index := 0

func open(max_value):
	if index >= get_child_count():
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

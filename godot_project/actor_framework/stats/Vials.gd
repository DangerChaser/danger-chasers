extends Node2D

signal vial_initialized
signal vial_started(max_value)
signal vial_finished
signal ticked(value)

var active_vial
var index := 0


func _ready() -> void:
	for vial in get_children():
		emit_signal("vial_initialized")

func start() -> void:
	if get_child_count() == 0 or index >= get_child_count():
		return
	
	var vial = get_child(index)
	if not vial.active:
		vial.connect("started", self, "vial_started")
		vial.connect("finished", self, "vial_finished")
		vial.connect("ticked", self, "vial_tick")
		vial.start()


func vial_started(max_value):
	emit_signal("vial_started", max_value)


func vial_tick(value):
	emit_signal("ticked", value)


func vial_finished() -> void:
	emit_signal("vial_finished")
	index += 1

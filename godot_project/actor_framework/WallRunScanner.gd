extends Area2D


var enabled := true
var can_wall_run := false


func _ready() -> void:
	set_physics_process(false)


func _input(event):
	if get_overlapping_areas().size() > 0 and event.is_action_pressed("ui_up"):
		match owner.state_machine.current_state.name:
			"Idle":
				owner.state_machine.change_state("WallRun")
				set_physics_process(true)


func _physics_process(delta):
	if owner.state_machine.current_state.name == "WallRun":
		if get_overlapping_areas().size() == 0:
			owner.state_machine.change_state("Air")
	else:
		set_physics_process(false)

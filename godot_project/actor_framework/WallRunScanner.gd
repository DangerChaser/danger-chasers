extends Area2D


var enabled := true
var can_wall_run := false


#func _ready() -> void:
#	set_physics_process(false)


#func _input(event):
#	if (get_overlapping_areas().size() > 0 or get_overlapping_bodies().size() > 0) and event.is_action_pressed("ui_up"):
#		match owner.state_machine.current_state.name:
#			"Idle":
#				owner.state_machine.change_state("WallRun")
#				set_physics_process(true)

#
#func _physics_process(delta):
#	var state = owner.state_machine.current_state
#	if state.name == "WallRun":
#		var external_args = {
#			"velocity": state.motion.external.velocity,
#			"target_direction": state.motion.external.target_direction,
#			"target_speed": state.motion.external.target_speed,
#			"mass": state.motion.external.mass
#		}
#		var args = {
#			"velocity" : state.motion.steering.velocity, 
#			"gravity_speed" : 0, 
#			"target_direction" : Vector2.UP, 
#			"input_key" : "ui_up",
#			"external" : external_args
#		}
#		args["target_direction"].x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int 
#		if get_overlapping_areas().size() == 0:
#			owner.state_machine.change_state("Air", args)
#	else:
#		set_physics_process(false)

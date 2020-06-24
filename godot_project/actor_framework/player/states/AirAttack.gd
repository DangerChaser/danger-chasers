extends AttackState
class_name AirAttackState

var to_state := ""


func _input(event):
	var attacks = weapon.attacks
	if not attacks.state == attacks.State.IDLE:
		if owner.state_machine.has_state("Stomp") and event.is_action_pressed("ui_down"):
			var args = weapon.get_exit_args()
			args["input_key"] = "ui_down"
			args["target_direction"] = Vector2.DOWN
			args["target_direction"].x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int 
			args["initial_animation"] = "stomp"
			emit_signal("finished", "Stomp", args)

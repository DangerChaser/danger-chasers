extends AttackState
class_name BackState

const DROP_THRU_BIT = 6

var to_state := ""

func _physics_process(delta:float) -> void:
	var attacks = weapon.attacks
	if attacks.state == attacks.State.LISTENING:
		if Input.is_action_pressed("ui_up"):
			to_state = "Up"
		elif input == "ui_right" and Input.is_action_pressed("ui_left"):
			to_state = "Forward"
		elif input == "ui_left" and Input.is_action_pressed("ui_right"):
			to_state = "Forward"
	
	if Input.is_action_pressed('ui_down'):
		owner.set_collision_mask_bit(DROP_THRU_BIT, false)
		if not owner.is_on_floor():
			var args = { }
			args["input_key"] = "ui_down"
			args["target_direction"] = Vector2.DOWN 
			emit_signal("finished", "Stomp", args)
	
	if attacks.state == attacks.State.REGISTERED and attacks.ready_for_next_attack or attacks.can_cancel:
		match to_state:
			"Up":
				var args = weapon.get_exit_args()
				args["input_key"] = "ui_up"
				args["target_direction"] = Vector2.UP
				args["target_direction"].x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int 
				emit_signal("finished", to_state, args)
			"Forward":
				var args = weapon.get_exit_args()
				if input == "ui_right":
					args["input_key"] = "ui_left"
					args["target_direction"] = Vector2.LEFT
				else:
					args["input_key"] = "ui_right"
					args["target_direction"] = Vector2.RIGHT
				emit_signal("finished", to_state, args)
		to_state = ""


func take_damage(args := {}):
	emit_signal("finished", "Stagger", args)
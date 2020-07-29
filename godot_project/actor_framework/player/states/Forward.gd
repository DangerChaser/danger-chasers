extends AttackState
class_name ForwardState

const DROP_THRU_BIT = 6
var to_state := ""


func _input(event):
	if Input.is_action_pressed("light_attack"):
		finished("LightAttack")


func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_up"):
		var args = weapon.get_exit_args()
		args["target_direction"] = Vector2.UP
		args["input_key"] = "ui_up"
		args["target_direction"].x = Input.is_action_pressed("ui_right") as int - Input.is_action_pressed("ui_left") as int 
		finished("Up", args)
		return
	
	if Input.is_action_pressed('ui_down'):
		owner.set_collision_mask_bit(DROP_THRU_BIT, false)
		if not owner.is_on_floor():
			var args = { }
			args["input_key"] = "ui_down"
			args["target_direction"] = Vector2.DOWN 
			finished("Stomp", args)
	
	var attacks = weapon.attacks
	if attacks.state == attacks.State.LISTENING:
		if input == "ui_right" and Input.is_action_pressed("ui_left") \
				or input == "ui_left" and Input.is_action_pressed("ui_right"):
			to_state = "Back"
	
	if attacks.state == attacks.State.REGISTERED and attacks.ready_for_next_attack or attacks.can_cancel:
		var args = weapon.get_exit_args()
		args["velocity"] = Vector2()
		match to_state:
			"Back":
				if input == "ui_right":
					args["input_key"] = "ui_left"
					args["target_direction"] = Vector2.LEFT
					args["look_direction"] = Vector2.RIGHT
					emit_signal("finished", to_state, args)
				else:
					args["input_key"] = "ui_right"
					args["target_direction"] = Vector2.RIGHT
					args["look_direction"] = Vector2.LEFT
					emit_signal("finished", to_state, args)
		to_state = ""


func take_damage(args := {}):
	finished("Stagger", args)

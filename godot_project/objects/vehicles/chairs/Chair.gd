extends Vehicle


func _physics_process(delta):
	var inputs = ["ui_up", "ui_left", "ui_right", "ui_down", "light_attack"]
	for input in inputs:
		if Input.is_action_pressed(input):
			finished("Idle")

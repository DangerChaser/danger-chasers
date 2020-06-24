extends IdleState
class_name ConstantMotion


func _physics_process(delta : float) -> void:
	if Input.is_action_pressed('ui_up'):
		register_jump()
	
	if not active:
		return
	
	if owner.state_machine.has_state("Stomp") and Input.is_action_pressed('ui_down'):
		air_timer.stop()
		air_timer_duration = 0.05
		if not owner.is_on_floor():
			var args = { "velocity": motion.steering.velocity }
			args["input_key"] = "ui_down"
			args["target_direction"] = Vector2(motion.steering.velocity.x, Vector2.DOWN.y)
			emit_signal("finished", "Stomp", args)
			return
	
	if not owner.is_on_floor():
		if air_timer.time_left <= 0.0:
			air_timer.start(original_air_timer_duration)
		return
	else:
		air_timer.stop()
	
	var direction = Vector2.RIGHT.rotated(owner.get_rotation())
	motion.move(direction)
	if owner.animation_player.current_animation == animation or owner.animation_player.current_animation == run_animation or owner.animation_player.current_animation == walk_animation:
		if motion.steering.velocity.length() > motion.steering.max_speed * stand_still_threshold_percent:
			owner.animation_player.play(run_animation)
		else:
			owner.animation_player.play(animation)

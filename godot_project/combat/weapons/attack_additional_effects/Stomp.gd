extends MovementEffect
class_name Stomp


func enter(args:={}) -> void:
	.enter(args)
	set_physics_process(false)
	
	if args.has("velocity"):
		var x_speed = args["velocity"].x
		motion.steering.velocity.x = x_speed
	var weapon = get_parent().get_parent().get_parent().get_parent().get_parent()
	weapon.input = ''
	motion.gravity.speed = initial_speed
	
	$Timer.start()


func exit() -> void:
	.exit()
	$Timer.stop()


func _physics_process(delta:float) -> void:
	if owner.is_on_floor():
		var attacks = weapon.get_node("Pivot/Attacks")
		var jump_registered = attacks.state == attacks.State.REGISTERED_JUMP
		attacks.attack()
		if jump_registered:
			attacks.state = attacks.State.REGISTERED_JUMP


func _on_Timer_timeout():
	set_physics_process(true)

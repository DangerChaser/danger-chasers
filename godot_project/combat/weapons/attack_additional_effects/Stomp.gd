extends MovementEffect
class_name Stomp


func enter(args:={}) -> void:
	.enter(args)
	if args.has("velocity"):
		var x_speed = args["velocity"].x
		motion.steering.velocity.x = x_speed
	var weapon = get_parent().get_parent().get_parent().get_parent().get_parent()
	weapon.input = ''
	motion.gravity.speed = initial_speed


func _physics_process(delta:float) -> void:
	if owner.is_on_floor():
		var attacks = get_parent().get_parent().get_parent()
		var jump_registered = attacks.state == attacks.State.REGISTERED_JUMP
		attacks.attack()
		if jump_registered:
			attacks.state = attacks.State.REGISTERED_JUMP

extends MotionState

export(String) var animation : String = "walk"


func enter(args := {}) -> void:
	.enter(args)
	if owner.animation_player.has_animation(animation):
		owner.animation_player.play(animation)


func _physics_process(delta : float) -> void:
	if Input.is_action_pressed("dash"):
		emit_signal("finished", "Dash")
	
	var direction = get_input_direction()
	move(direction)
	if not direction and steering.velocity.length() <= steering.arrive_distance:
		emit_signal("finished", "Idle", {"velocity":Vector2()})


func handle_input(event : InputEvent) -> void:
	for i in range(1, 9):
		var input_skill = "skill_" + str(i)
		if event.is_action_pressed(input_skill):
			emit_signal("finished", "Job", {"input":input_skill, "velocity":steering.velocity})


func take_damage(args := {}):
	emit_signal("finished", "Stagger", args)
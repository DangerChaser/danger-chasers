extends MotionState

export(String) var animation : String = "walk"


func enter(args := {}) -> void:
	.enter(args)
	owner.play_animation(animation)


func _physics_process(delta : float) -> void:
	if Input.is_action_pressed("dash"):
		finished("Dash")
	
	var direction = get_input_direction()
	move(direction)
	if not direction and steering.velocity.length() <= steering.arrive_distance:
		finished("Idle", {"velocity":Vector2()})


func handle_input(event : InputEvent) -> void:
	for i in range(1, 9):
		var input_skill = "skill_" + str(i)
		if event.is_action_pressed(input_skill):
			finished("Job", {"input":input_skill, "velocity":steering.velocity})


func take_damage(args := {}):
	finished("Stagger", args)

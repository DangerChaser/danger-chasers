extends MotionState

export(String) var animation : String = "run"

export var initial_speed : int
export var initial_dash_duration : float = 0.1
var initial_dash_timer : Timer

func _ready() -> void:
	assert_values()
	make_initial_dash_timer()

func assert_values() -> void:
	if steering.max_speed == 0:
		print("Max speed of Dash state of %s is 0." % owner.name)
	if initial_speed == 0:
		print("Initial speed of Dash state of %s is 0." % owner.name)
	if initial_dash_duration == 0:
		print("Initial dash duration of Dash state of %s is 0 seconds." % owner.name)
	assert (mass != 0)

func make_initial_dash_timer() -> void:
	initial_dash_timer = Timer.new()
	initial_dash_timer.wait_time = initial_dash_duration
	initial_dash_timer.one_shot = true
	add_child(initial_dash_timer)


func enter(args := {}) -> void:
	.enter(args)
	initial_dash_timer.start()
	if owner.animation_player.has_animation(animation):
		owner.animation_player.play(animation)


func exit() -> void:
	initial_dash_timer.stop()


func _physics_process(delta : float) -> void:
	if not Input.is_action_pressed("dash") and initial_dash_timer.is_stopped():
		emit_signal("finished", "Walk", {"velocity":steering.velocity})
	
	var direction = get_input_direction()
	if initial_dash_timer.is_stopped():
		var target_position : Vector2 = owner.position + direction.normalized() * steering.max_speed
		steering.velocity = Steering.follow(steering.velocity, owner.global_position, target_position, steering.max_speed, steering.mass)
		steering.velocity = steering.velocity.normalized() * steering.max_speed
	else:
		if direction:
			steering.velocity = direction.normalized() * initial_speed
		else:
			steering.velocity = steering.velocity.normalized() * initial_speed
	owner.move_and_slide(steering.velocity)
	update_look_direction(steering.velocity.normalized())
	last_move_direction = steering.velocity.normalized()


func _input(event : InputEvent) -> void:
	for i in range(1, 9):
		var input_skill = "skill_" + str(i)
		if event.is_action_pressed(input_skill):
			emit_signal("finished", "Job", {"input":input_skill, "velocity":steering.velocity})


func take_damage(args := {}):
	emit_signal("finished", "Stagger", args)

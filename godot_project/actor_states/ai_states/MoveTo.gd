extends State
class_name MoveToState

export(String) var animation : String = "walk"
export(String) var next_state : String = ""
export(float) var roam_radius : float = 150.0
export(bool) var disable_obstacle_collider := false
export(bool) var stagger := false

onready var motion := $Motion
onready var timer := $Timer

var target_position : Vector2 = Vector2()
var start_position : Vector2 = Vector2()


func enter(args := {}) -> void:
	.enter(args)
	motion.enter(args)
	if owner.animation_player.has_animation(animation):
		owner.animation_player.play(animation)
	start_position = owner.global_position
	if disable_obstacle_collider \
			or (args.has("disable_collider_in_state") and args["disable_collider_in_state"] == true):
		owner.set_collision_mask_bit(GameManager.Layers.OBSTACLES, false)
	else:
		timer.start()
	if args.has("target_position"):
		target_position = args["target_position"]
	else:
		target_position = calculate_new_target_position()


func exit() -> void:
	.exit()
	motion.exit()
	timer.stop()
	owner.set_collision_mask_bit(GameManager.Layers.OBSTACLES, true)


func _physics_process(delta : float) -> void:
	var buffer = 6.0
	motion.move_to(target_position)
	if owner.global_position.distance_to(target_position) < motion.steering.arrive_distance:
		emit_signal("finished", next_state)


func calculate_new_target_position() -> Vector2:
	var random_angle = randf() * 2 * PI
	var random_radius = randf() * roam_radius / 2
	random_radius += roam_radius / 2
	return start_position + Vector2(cos(random_angle), sin(random_angle)) * random_radius


func take_damage(args := {}):
	if stagger:
		emit_signal("finished", "Stagger", args)


func _on_Timer_timeout():
	emit_signal("finished", next_state, motion.get_exit_args())

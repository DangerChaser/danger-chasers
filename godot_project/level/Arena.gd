extends Node2D
class_name Arena

signal started
signal next_round_started(current_round)
signal all_actors_died
signal actor_died(actor)
signal finished

export(bool) var change_camera := true

onready var round_manager := $RoundManager
onready var actor_spawn_groups := $ActorSpawnGroups
onready var walls := $Walls
onready var camera_limit := $CameraLimitTrigger
onready var activation_area := $ActivationArea

var number_actors : int
var actors := []
var y_sort


func _ready() -> void:
	disable_walls()
	connect("all_actors_died", round_manager, "next_round")

func initialize(target_y_sort : YSort) -> void:
	y_sort = target_y_sort


func _on_ActivationArea_area_entered(area):
	if not area is ActivationArea or not area.owner is PlayerActor:
		return
	start()


func start():
	activation_area.disable()
	if change_camera:
		camera_limit.change()
	enable_walls()
	next_round_started(0)
	emit_signal("started")


func next_round_started(current_round : int) -> void:
	if current_round >= $ActorSpawnGroups.get_child_count():
		finish()
		return
	
	var group = round_manager.get_group(current_round)
	if group >= round_manager.actor_group_round_thresholds.size() - 1:
		call_deferred("spawn_actors", group, 1.0)
		return

	var next_threshold = round_manager.actor_group_round_thresholds[group]
	var previous_threshold = 0 if group == 0 else round_manager.actor_group_round_thresholds[group - 1]
	var interval_size = next_threshold - previous_threshold
	var numerator = current_round
	if current_round >= previous_threshold:
		numerator = current_round - previous_threshold
	numerator = max(numerator, 1)
	var percent = float(numerator) / interval_size
	call_deferred("spawn_actors", group, percent)
	
	emit_signal("next_round_started", current_round)


func spawn_actors(index : int, percent : float) -> void:
	var actor_team_pairs = actor_spawn_groups.spawn_actors(index, percent, y_sort)
	call_deferred("initialize_actors", actor_team_pairs)


func initialize_actors(actor_team_pairs : Array) -> void:
	actors = []
	for actor_team in actor_team_pairs:
		var actor = actor_team["actor"]
		actors.push_back(actor)
		actor.initialize(actor_team["team"])
		actor.target.call_deferred("lock_on") # Call lock on after initializing teams, or else actors will target each other
		actor.connect("died", self, "actor_died")
	number_actors += actors.size()


func actor_died(actor) -> void:
	emit_signal("actor_died", actor)
	actors.remove(actors.find(actor))
	number_actors -= 1
	if number_actors == 0:
		emit_signal("all_actors_died")


func finish() -> void:
	disable_walls()
	emit_signal("finished")


func enable_walls() -> void:
	for wall in walls.get_children():
		var collider = wall.get_child(0)
		assert (collider is CollisionShape2D or collider is CollisionPolygon2D)
		collider.set_deferred("disabled", false)


func disable_walls() -> void:
	for wall in walls.get_children():
		var collider = wall.get_child(0)
		assert (collider is CollisionShape2D or collider is CollisionPolygon2D)
		collider.set_deferred("disabled", true)


func kill_all_actors() -> void:
	for actor in actors:
		actor.queue_free()
	actors.clear()

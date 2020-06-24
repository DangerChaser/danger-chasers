extends ActorSpawner


export(NodePath) var parent
export(bool) var repeat_on_spawn := true

var actors = []

func _ready() -> void:
	parent = get_node(parent)


func enable() -> void:
	$Timer.start()


func disable() -> void:
	$Timer.stop()


func spawn(_parent=null):
	var actor = .spawn(parent)
	call_deferred("initialize_actor", actor)
	actors.push_back(actor)
	
	if repeat_on_spawn:
		enable()


func initialize_actor(actor) -> void:
	actor.initialize(team)
	actor.target.call_deferred("lock_on") # Call lock on after initializing teams, or else enemies will target each other


func actor_died(actor) -> void:
	.actor_died(actor)
	if actors.has(actor):
		actors.remove(actors.find(actor))


func free_all_actors() -> void:
	for actor in actors:
		actor.queue_free()
	actors = []

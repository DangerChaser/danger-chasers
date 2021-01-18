extends WaitTime

export var actor : PackedScene

var actors : Array = []


func _ready():
	for spawner in $Spawners.get_children():
		if spawner.object == null:
			spawner.object = actor

func enter(args := {}) -> void:
	.enter(args)
	spawn()


func spawn(args:={}):
	for spawner in $Spawners.get_children():
		var actor = spawner.spawn(GameManager.level.y_sort)
		actor.connect("died", self, "actor_died")
		actor.call_deferred("initialize", owner.team)
		actor.get_node("Target").call_deferred("lock_on")
		actors.push_back(actor)


func actor_died(actor) -> void:
	actors.erase(actor)


func kill_actors() -> void:
	for actor in actors:
		actor.kill()

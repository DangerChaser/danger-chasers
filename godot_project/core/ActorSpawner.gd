tool
extends ObjectSpawner
class_name ActorSpawner

signal actor_died

export var team := "team_2"
export var actor_name := ""


func spawn(parent=null):
	var actor = .spawn()
	actor.connect("died", self, "actor_died")
	if actor_name:
		actor.name = actor_name
	actor.initialize_on_ready = false
	if parent:
		parent.add_child(actor)
	return actor


func actor_died(actor):
	emit_signal("actor_died")

tool
extends ObjectSpawner
class_name ActorSpawner

signal actor_died

export(String) var team := "team_2"
export var actor_name := ""


func spawn(parent=null):
	var actor = .spawn(parent)
	actor.connect("died", self, "actor_died")
	if actor_name:
		actor.name = actor_name
	return actor


func actor_died(actor):
	emit_signal("actor_died")

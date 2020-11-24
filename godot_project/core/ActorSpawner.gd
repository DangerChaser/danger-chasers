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
#	actor.get_node("Pivot").teleport()
	initialize_actor(actor)
	return actor


func actor_died(actor):
	emit_signal("actor_died")


func initialize_actor(actor) -> void:
	pass
#	actor.initialize(team)

extends Attack
class_name ActorSpawnAttack

var actors : Array = []

func spawn(args:={}):
	$Sfx.play()
	for spawner in $Spawners.get_children():
		var actor = spawner.spawn(GameManager.level.y_sort)
		actor.connect("died", self, "actor_died")
		actor.connect("weapon_added", self, "_on_weapon_added")
		actor.call_deferred("initialize", owner.team)
		actor.get_node("Target").call_deferred("lock_on")
		actors.push_back(actor)


func actor_died(actor) -> void:
	actors.erase(actor)


func _on_weapon_added(weapon) -> void:
	weapon.set_input_key(input)


func kill_actors() -> void:
	for actor in actors:
		actor.kill()

extends State
class_name ManagedState

export var next_state := ""
export var unhittable_effect : PackedScene
var manager


func enter(args := {}) -> void:
	.enter(args)
	manager = args["manager"]
	owner.stats.buffs.add(unhittable_effect.instance())


func exit() -> void:
	.exit()
	queue_free()
	owner.stats.buffs.remove("Unhittable")


func _physics_process(delta):
	owner.global_position = manager.global_position
	owner.set_rotation(manager.rotation)
	owner.scale = manager.scale
	owner.visible = manager.visible


func finished(_next_state:="", args:={}) -> void:
	if not _next_state:
		_next_state = next_state
	.finished(_next_state)

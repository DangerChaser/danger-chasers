extends State
class_name ManagedState

export var next_state := ""
var manager


func enter(args := {}) -> void:
	.enter(args)
	manager = args["manager"]


func exit() -> void:
	.exit()
	queue_free()

func _physics_process(delta):
	owner.global_position = manager.global_position
	owner.scale = manager.scale
	owner.set_rotation(manager.rotation)


func finished(_next_state:="", args:={}) -> void:
	if not _next_state:
		_next_state = next_state
	finished(_next_state, args)

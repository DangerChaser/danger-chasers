extends Node2D

export var vehicle : PackedScene

onready var actor_position := $ActorPosition # Should be BOTTOM OF KNEE level

func start(actor) -> void:
	actor.global_position = actor_position.global_position
	var vehicle_state = vehicle.instance()
	actor.state_machine.add_child(vehicle_state)
	actor.state_machine.change_state(vehicle_state.name)
	actor.set_rotation(rotation)

func _on_CollisionTrigger_area_entered(area):
	start(area.owner)

func _on_InteractionArea_interacted_with_actor(actor):
	start(actor)

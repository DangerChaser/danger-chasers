extends ActorManagedStateManager


func enable() -> void:
	actor = PlayerManager.player
	var state : ManagedState = managed_state.instance()
	actor.state_machine.add_child(state)
	actor.state_machine.change_state(state.name, {"manager": self})
	PlayerManager.disable_input()


func disable() -> void:
	.disable()
	PlayerManager.enable_input()

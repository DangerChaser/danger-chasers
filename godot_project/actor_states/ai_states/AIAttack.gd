extends AttackState

export(bool) var can_loop : bool = false
export var one_time := false

onready var timer : Timer = $Timer


func enter(args := {}) -> void:
	.enter(args)
	weapon.attacks.can_loop = can_loop
	timer.start()


func exit() -> void:
	timer.stop()
	.exit()
	if one_time:
		weapon.queue_free()
		queue_free()


func _physics_process(delta:float) -> void:
	if not weapon.attacks.state == weapon.attacks.State.LISTENING:
		return
	weapon.attacks.register_attack()


func take_damage(args := {}):
	if stagger and owner.state_machine.has_state("Stagger"):
		finished("Stagger", args)


func _on_Timer_timeout():
	if not active:
		return
	weapon.emit_signal("finished")


func pause() -> void:
	.pause()
	if timer:
		timer.paused = true


func unpause() -> void:
	.unpause()
	if timer:
		timer.paused = false

extends AttackAdditionalEffect

export var tiles_one_way := 3.0
export var duration_one_way := 1.0

onready var tween : Tween = $Tween

enum States { UP, DOWN }
var state = States.UP

func enter(args := {}) -> void:
	.enter(args)
	
	state = States.DOWN # This sets it so it goes up first
	_on_Tween_tween_all_completed()


func exit() -> void:
	.exit()
	state = States.DOWN


func _on_Tween_tween_all_completed():
	var target_position : Vector2 = Vector2(owner.global_position.x, owner.global_position.y - Utilities.tile2unit(tiles_one_way))
	if state == States.UP:
		state = States.DOWN
		target_position = Vector2(owner.global_position.x, owner.global_position.y + Utilities.tile2unit(tiles_one_way) * 2)
	else:
		state = States.UP
		target_position = Vector2(owner.global_position.x, owner.global_position.y - Utilities.tile2unit(tiles_one_way) * 2)
	tween.interpolate_property(owner, \
			"global_position", \
			owner.global_position, \
			target_position, \
			duration_one_way, \
			Tween.TRANS_QUAD, \
			Tween.EASE_IN_OUT)
	tween.start()




func pause() -> void:
	tween.stop_all()

func unpause() -> void:
	tween.resume_all()

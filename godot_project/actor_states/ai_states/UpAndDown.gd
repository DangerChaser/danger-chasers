extends State
class_name UpAndDown

export var animation := "fly"
export var next_state := ""
export var tiles_one_way := 3.0
export var duration_one_way := 1.0
export var stagger := false
export var wait_forever := true

onready var timer : Timer = $Timer
onready var tween : Tween = $Tween

enum States { UP, DOWN }
var state = States.UP

func enter(args := {}) -> void:
	.enter(args)
	owner.play_animation(animation)
	
	if not wait_forever:
		timer.start()
	
	state = States.UP
	var target_position = Vector2(owner.global_position.x, owner.global_position.y - Utilities.tile2unit(tiles_one_way))
	tween.interpolate_property(owner, \
			"global_position", \
			owner.global_position, \
			target_position, \
			duration_one_way, \
			Tween.TRANS_QUAD, \
			Tween.EASE_OUT)
	tween.start()


func exit() -> void:
	.exit()
	tween.stop_all()


func _on_Timer_timeout():
	finished(next_state)


func _on_Tween_tween_all_completed():
	tween.stop_all()
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

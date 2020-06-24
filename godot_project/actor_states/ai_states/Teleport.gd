extends State

export(Array, NodePath) var teleport_to
export var teleport_in_animation := ""
export var teleport_out_animation := ""
export var next_state := ""

var target

func enter(args := {}) -> void:
	if not teleport_to.size() > 0:
		finished(next_state, args)
		return
	
	randomize()
	var index = randi() % teleport_to.size()
	target = get_node(teleport_to[index])
	
	if teleport_in_animation:
		owner.animation_player.play(teleport_in_animation)
	else:
		teleport()


func exit() -> void:
	.exit()


func teleport() -> void:
	owner.global_position = target.global_position
	if teleport_out_animation:
		owner.animation_player.play(teleport_out_animation)
	else:
		finished(next_state)

func anim_finished(anim_name : String) -> void:
	.anim_finished(anim_name)
	if anim_name == teleport_in_animation:
		teleport()
	elif anim_name == teleport_out_animation:
		finished(next_state)

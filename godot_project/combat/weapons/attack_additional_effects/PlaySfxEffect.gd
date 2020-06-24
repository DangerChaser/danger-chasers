extends AttackAdditionalEffect
class_name PlaySfxEffect

export(NodePath) var sfx_node : NodePath


func _ready() -> void:
	assert (sfx_node)

func enter(args := {}) -> void:
	.enter(args)
	play()


func play() -> void:
	get_node(sfx_node).play()

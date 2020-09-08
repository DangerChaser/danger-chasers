extends AttackAdditionalEffect

export var input := ""
export var next_state := ""

func _ready() -> void:
	assert(input)
	assert(next_state)

func _input(event : InputEvent):
	if event.is_action_pressed(input):
		finished(next_state)

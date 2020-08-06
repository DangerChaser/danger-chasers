extends State
class_name Job

export var next_state : String = ""
var input_to_skill : Dictionary
var current_skill


func _ready() -> void:
	for attack_state in get_children():
		input_to_skill[attack_state.input] = attack_state
		attack_state.connect("finished", self, "finished")


func add_child(node : Node, legible_unique_name:=false) -> void:
	assert (node is AttackState)
	.add_child(node, legible_unique_name)
	input_to_skill[node.input] = node
	node.connect("finished", self, "finished")


func set_owner(new_owner) -> void:
	owner = new_owner
	for child in get_children():
		child.owner = owner


func finished(next_state := "", args := {}):
	emit_signal("finished", next_state, args)


func enter(args := {}) -> void:
	.enter(args)
	if not args.has("input_key"):
		print("Entered hotbar state but has no input skill!")
		assert (false)
	var input = args["input_key"]
	args.erase("input_key")
	if check_input(input):
		if current_skill and not current_skill == input_to_skill[input]:
			current_skill.exit()
		current_skill = input_to_skill[input]
		current_skill.enter(args)
		return
	finished(next_state, args)


func check_input(input:String) -> bool:
	return input_to_skill.has(input)


func exit() -> void:
	current_skill.exit()
	current_skill = null


func anim_finished(anim_name : String) -> void:
	current_skill.anim_finished(anim_name)


func skill_ready(input_key : String) -> bool:
	if check_input(input_key):
		var skill_to_check = input_to_skill[input_key]
		return skill_to_check.weapon.is_ready()
	return false


func pause() -> void:
	.pause()
	if current_skill:
		current_skill.pause()


func unpause() -> void:
	.unpause()
	if current_skill:
		current_skill.unpause()

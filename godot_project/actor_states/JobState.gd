extends State
class_name JobState

export(PackedScene) var job_scene : PackedScene
var current_job : Job


func _ready() -> void:
	current_job = job_scene.instance()
	current_job.connect("finished", self, "finished")
	add_child(current_job)
	current_job.set_owner(owner)


func finished(next_state := "Idle", args := {}):
	if next_state == "":
		if owner.is_on_floor():
			next_state = "Idle"
		else:
			next_state = "Air"
	emit_signal("finished", next_state, args)


func enter(args := {}) -> void:
	.enter(args)
	current_job.enter(args)


func exit() -> void:
	.exit()
	current_job.exit()


func anim_finished(anim_name : String) -> void:
	current_job.anim_finished(anim_name)


func skill_ready(input_key : String) -> bool:
	return current_job.skill_ready(input_key)


func get_current_skill():
	return current_job.current_skill.weapon

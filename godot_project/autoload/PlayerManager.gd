extends Node

var skills := {}
var gold := 0

var active_skills := []


func _ready() -> void:
	for skill in $JobSkills.get_children():
		skills[skill.name] = skill
		skill.get_node("Weapons").name = skill.name


func activate_skill(name : String, experience:=-1) -> void:
	var skill = skills[name]
	if experience >= 0:
		skill.set_experience(experience)
	var new_skill = skill.get_node(name).duplicate()
	skill.connect("stats_changed", new_skill, "set_weapon_through_stats")
	var player = GameManager.get_player()
	new_skill.input = "skill_" + str(player.job.get_child_count() + 1)
	player.job.add_child(new_skill)
	new_skill.owner = player
	new_skill.set_weapon_through_stats(skill.character_stats)
	player.player_hud.call_deferred("set_hotbars", player.job)
	
	if not active_skills.has(name):
		active_skills.append(name)


func enable_input() -> void:
	if GameManager.players.size() > 0:
		var player = GameManager.get_player()
		if player and player.state_machine.get_current_state().name == "Wait":
			player.state_machine.initialize()


func disable_input() -> void:
	if GameManager.players.size() > 0:
		var player = GameManager.get_player()
		if player:
			player.state_machine.change_state("Wait")

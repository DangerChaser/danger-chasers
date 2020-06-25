extends Actor
class_name PlayerActor

onready var player_hud := $PlayerHUDLayer/BattleHUD
var job : Job


func _ready() -> void:
	yield(get_tree().create_timer(0.01), "timeout") # Give animation player time to play SETUP
	player_hud.initialize(self, icon)
	if not get_node("Stats").is_connected("stats_changed", player_hud, "update_stats"):
		get_node("Stats").connect("stats_changed", player_hud, "update_stats")
	
	job = $StateMachine/Job.current_job
	player_hud.set_hotbars(job)
	
	for skill in PlayerManager.active_skills:
		PlayerManager.activate_skill(skill)
#	PlayerManager.activate_skill("TillSummon")
#	PlayerManager.activate_skill("ShotgunBlast")
#	PlayerManager.activate_skill("LavaLauncher")


func _input(event : InputEvent) -> void:
	var state = state_machine.get_current_state()
	if state != state_machine.get_state("Die") and state != state_machine.get_state("Stagger") and state != state_machine.get_state("Cutscene"):
		for i in range(1, 9):
			var input_skill = "skill_" + str(i)
			if event.is_action_pressed(input_skill):
				var current_state = state_machine.get_current_state()
				if current_state.name == "Job":
					if not current_state.get_current_skill().attacks.can_cancel:
						return
				if state_machine.get_state("Job").skill_ready(input_skill):
					state_machine.change_state("Job", {"input_key":input_skill})

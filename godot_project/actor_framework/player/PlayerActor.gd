extends Actor
class_name PlayerActor

onready var player_hud := $PlayerHUDLayer/BattleHUD
onready var activation_scanner : ActivationArea = $ActivationScanner
var job : Job


func _ready() -> void:
	set_process_input(false)
	activation_scanner.disable()
	
	yield(get_tree().create_timer(0.01), "timeout") # Give animation player time to play SETUP
	
	player_hud.initialize(self, icon)
	
	job = $StateMachine/Job.current_job
	player_hud.set_hotbars(job)
	
	yield(get_tree().create_timer(1.0), "timeout") # Prevents occasional crash from job not being declared
#	for skill in PlayerManager.active_skills:
#		PlayerManager.activate_skill(skill)
#	PlayerManager.activate_skill("TillSummon")
#	PlayerManager.activate_skill("ShotgunBlast")
#	PlayerManager.activate_skill("LavaLauncher")
	PlayerManager.activate_skill("Dash")


func initialize(_team : String = "", initial_target=null) -> void:
	.initialize()
	set_process_input(true)
	activation_scanner.enable()


func _input(event : InputEvent) -> void:
	if not input_enabled:
		return
	
	var state = state_machine.get_current_state()
	if state != state_machine.get_state("Die") and state != state_machine.get_state("Stagger") and state != state_machine.get_state("Cutscene"):
		for i in range(1, 9):
			var input_skill = "skill_" + str(i)
			if event.is_action_pressed(input_skill):
				var current_state = state_machine.get_current_state()
				if current_state.name == "Job":
					if not current_state.get_current_skill().attacks._can_cancel_animation:
						return
				if state_machine.get_state("Job").skill_ready(input_skill):
					state_machine.change_state("Job", {"input_key":input_skill})

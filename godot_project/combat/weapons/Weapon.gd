extends Node2D
class_name Weapon

signal attack_started(actor_animation)
signal not_ready()
signal finished()

var friendly_teams : Array = []

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var attacks : Attacks = $Pivot/Attacks
onready var cooldown_timer : Timer = $CooldownTimer
onready var gcd_timer := Timer.new()

export var icon : Texture
export var global_cooldown := false
export var next_state := ""
export var input : String

var active_after_exit : bool = false
var active : bool


func _ready() -> void:
	animation_player.play("SETUP")
	
	gcd_timer.one_shot = true
	gcd_timer.wait_time = GameManager.global_cooldown
	add_child(gcd_timer)


func set_input_key(key : String):
	input = key
	$Pivot/Attacks.input = input
	for attack in $Pivot/Attacks.get_children():
		attack.input = input


func set_friendly_teams(_friendly_teams : Array) -> void:
	friendly_teams = _friendly_teams
	for attack in $Pivot/Attacks.get_children():
		if attack is SpawnGroup:
			attack.friendly_teams = friendly_teams
	for child in Utilities.get_all_subchildren(self):
		if child is DamageSource:
			child.friendly_teams = friendly_teams


func enter(args := {}) -> void:
	active = true
	
	if cooldown_timer.time_left > 0 or gcd_timer.time_left > 0:
		emit_signal("not_ready", args)
		return
	
	attacks.enter(args)


func is_ready() -> bool:
	if attacks.grounded and not owner.is_on_floor():
		return false
	if cooldown_timer.time_left > 0 or gcd_timer.time_left > 0:
		return false
	return true


func exit() -> void:
	active = false
	
	if active_after_exit:
		return
	
	attacks.exit()
	animation_player.stop()
	if animation_player.has_animation("SETUP"):
		animation_player.play("SETUP")


func start_global_cooldown() -> void:
	if global_cooldown:
		gcd_timer.start()


func get_exit_args() -> Dictionary:
	return attacks.get_exit_args()


func set_owner(_owner) -> void:
	owner = _owner
	for child in Utilities.get_all_subchildren(self):
		child.owner = owner


func pause() -> void:
	attacks.pause()
	animation_player.stop(false)


func unpause() -> void:
	attacks.unpause()
	animation_player.play()


func _on_Attacks_attack_started(actor_animation, weapon_animation):
	animation_player.stop()
	animation_player.play(weapon_animation)
	cooldown_timer.start()
	emit_signal("attack_started", actor_animation)


func _on_Attacks_finished(state_override : String = "", args := {}):
	finish(state_override, args)


func finish(state_override : String = "", args := {}) -> void:
	var exit_args = get_exit_args()
	for key in exit_args.keys():
		args[key] = exit_args[key]
	
	if not state_override:
		state_override = next_state
	
	if not active and active_after_exit:
		return
	
	emit_signal("finished", state_override, args)

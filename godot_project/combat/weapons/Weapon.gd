extends Node2D
class_name Weapon

signal attack_started(actor_animation)
signal not_ready()
signal finished()

var friendly_teams : Array = []

onready var animation_player : AnimationPlayer = $AnimationPlayer
onready var attacks := $Pivot/Attacks
onready var cd_timer := Timer.new()
onready var gcd_timer := Timer.new()

export(Texture) var icon : Texture
export(float) var cooldown := 0.5
export(bool) var global_cooldown := false
export(String) var next_state := ""

var input : String
var sprite


func _ready() -> void:
	assert (animation_player)
	animation_player.connect("animation_finished", attacks, "_on_animation_finished")
	animation_player.play("SETUP")
	
	if has_node("Pivot/Sprite"):
		sprite = $Pivot/Sprite
	
	cd_timer.one_shot = true
	if cooldown <= 0: # gives an error during runtime if this line is not here
		cd_timer.wait_time = 0.1
	else:
		cd_timer.wait_time = cooldown
	add_child(cd_timer)
	gcd_timer.one_shot = true
	gcd_timer.wait_time = GameManager.global_cooldown
	add_child(gcd_timer)


func show_sprite() -> void:
	if sprite:
		sprite.visible = true

func hide_sprite() -> void:
	if sprite:
		sprite.visible = false


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
		for child in Utilities.get_all_subchildren(attack):
			if child is DamageSource:
				child.friendly_teams = friendly_teams


func enter(args := {}) -> void:
	if cd_timer.time_left > 0 or gcd_timer.time_left > 0:
		emit_signal("not_ready", args)
		return
	
	attacks.enter(args)
	show_sprite()


func is_ready() -> bool:
	if attacks.grounded and not owner.is_on_floor():
		return false
	if cd_timer.time_left > 0 or gcd_timer.time_left > 0:
		return false
	return true


func exit() -> void:
	attacks.exit()
	animation_player.stop()
	if animation_player.has_animation("SETUP"):
		animation_player.play("SETUP")
	hide_sprite()


func _attack_started(actor_animation, weapon_animation) -> void:
	emit_signal("attack_started", actor_animation)
	animation_player.stop()
	animation_player.play(weapon_animation)
	if cooldown > 0.0:
		cd_timer.start()


func finished(state_override : String = "", args := {}) -> void:
	var exit_args = get_exit_args()
	for key in exit_args.keys():
		args[key] = exit_args[key]
	
	if not state_override:
		state_override = next_state
	
	emit_signal("finished", state_override, args)


func start_global_cooldown() -> void:
	if global_cooldown:
		gcd_timer.start()


func get_exit_args() -> Dictionary:
	return attacks.get_exit_args()


func set_owner(_owner) -> void:
	owner = _owner
	for child in Utilities.get_all_subchildren(self):
		child.owner = owner

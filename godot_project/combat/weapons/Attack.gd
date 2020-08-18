# All children of an Attack Node are additional effects
	# (player movement, knockback, status effects, etc.)
extends Node2D
class_name Attack

onready var additional_effects := $AdditionalEffects
onready var combo_effects := $ComboEffects
onready var exit_arguments := $ExitArguments

signal attack_started(actor_animation, weapon_animation)
signal finished
signal attack_input_listening_enabled
signal ready_for_next_attack_enabled
signal cancel_animation_enabled
signal hit_confirmed

export(String) var actor_animation := "slash_down"
export(String) var weapon_animation := "attack"

var combo_ready := false
var input


func _ready() -> void:
	for effect in additional_effects.get_children():
		effect.connect("finished", self, "effect_finished")
		effect.weapon = get_parent().get_parent().get_parent().get_parent()
	for effect in combo_effects.get_children():
		effect.connect("finished", self, "effect_finished")
		effect.weapon = get_parent().get_parent().get_parent().get_parent()
	if has_node("DamageSource"):
		$DamageSource.connect("hit_confirmed_no_actor", self, "emit_signal", ["hit_confirmed"])


func effect_finished(next_state:="", args:={}):
	get_parent()._attack_finished(next_state, args)


func enter(args := {}) -> void:
	for effect in additional_effects.get_children():
		effect.enter(args)
	if args.has("combo_ready") and args["combo_ready"] == true:
		combo_ready = true
		for effect in combo_effects.get_children():
			effect.enter(args)
	emit_signal("attack_started", actor_animation, weapon_animation)


func get_exit_args() -> Dictionary:
	var args = {}
	for effect in additional_effects.get_children():
		var exit_args = effect.get_exit_args()
		for key in exit_args.keys():
			args[key] = exit_args[key]
	if combo_ready == true:
		for effect in combo_effects.get_children():
			var exit_args = effect.get_exit_args()
			for key in exit_args.keys():
				args[key] = exit_args[key]
	for child in exit_arguments.get_children():
		var exit_args = child.get_exit_args()
		for key in exit_args.keys():
			args[key] = exit_args[key]
	return args


func exit() -> void:
	for effect in additional_effects.get_children():
		effect.exit()
	if combo_ready == true:
		combo_ready = false
		for effect in combo_effects.get_children():
			effect.exit()


func pause() -> void:
	for effect in additional_effects.get_children():
		effect.pause()
	for effect in combo_effects.get_children():
		effect.pause()


func unpause() -> void:
	for effect in additional_effects.get_children():
		effect.unpause()
	for effect in combo_effects.get_children():
		effect.unpause()

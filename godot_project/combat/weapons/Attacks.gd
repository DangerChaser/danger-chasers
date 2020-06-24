extends Node2D
class_name Attacks

signal attack_started(actor_animation, weapon_animation)
signal attacks_finished()

export(bool) var can_loop := false
export(bool) var grounded := true

enum State { IDLE, LISTENING, REGISTERED, REGISTERED_JUMP }

onready var weapon := get_parent().get_parent()

var state = State.LISTENING
var ready_for_next_attack := false
var current_attack
var current_index := 0
var can_cancel := false
var input : String


func _ready() -> void:
	assert(get_child_count() > 0)
	set_physics_process(false)


func enter(args := {}) -> void:
	reset()
	attack(args)


func exit() -> void:
	set_physics_process(false)
	reset()
	if current_attack: # Prevents crashing if you try to spam different weapons
		current_attack.exit()
		current_attack = null


func get_attack(index : int):
	return get_child(index)


func reset() -> void:
	current_index = 0


func _physics_process(delta : float) -> void:
	attack_if_ready()
	
	if state == State.IDLE:
		return
	
	if Input.is_action_pressed(input):
		register_attack()
	if Input.is_action_just_pressed("ui_up") and owner.is_in_group("players"):
		register_jump()
	if owner.is_in_group("players") and can_cancel and state == State.REGISTERED_JUMP:
		var args = {}
		if current_attack:
			args = current_attack.get_exit_args()
		if owner.state_machine.has_state("Up"):
			weapon.finished("Up", args)


func attack_if_ready(args := {}) -> void:
	if not state == State.REGISTERED or not ready_for_next_attack:
		return
	if grounded and not owner.is_on_floor():
		return
	
	if current_index < get_child_count():
		attack(args)

	if current_index >= get_child_count() and can_loop:
		reset()

func attack(args := {}):
	state = State.IDLE
	ready_for_next_attack = false
	can_cancel = false
	
	if current_attack:
		var exit_args = current_attack.get_exit_args()
		for key in exit_args.keys():
			args[key] = exit_args[key]
		current_attack.exit()
	
	current_attack = get_child(current_index)
	current_attack.enter(args)
	current_index += 1


func register_attack() -> void: # Here instead of in handle_input to hold it down
	state = State.REGISTERED

func register_jump() -> void: # Here instead of in handle_input to hold it down
	state = State.REGISTERED_JUMP


func _on_animation_finished(anim_name : String) -> void:
	if anim_name == "SETUP" or anim_name == "DISABLE":
		return
	weapon.finished("", current_attack.get_exit_args())


func _attack_started(actor_animation, weapon_animation) -> void:
	weapon._attack_started(actor_animation, weapon_animation)


func _attack_finished(next_state:="", args:={}):
	weapon.finished(next_state, args)


func get_exit_args() -> Dictionary:
	var args = {}
	for attack in get_children():
		var exit_args = attack.get_exit_args()
		for key in exit_args.keys():
			args[key] = exit_args[key]
	return args


'''Animation functions'''
func enable_attack_input_listening() -> void:
	state = State.LISTENING
	set_physics_process(true)

func enable_ready_for_next_attack() -> void:
	ready_for_next_attack = true

func enable_cancel_animation() -> void:
	can_cancel = true

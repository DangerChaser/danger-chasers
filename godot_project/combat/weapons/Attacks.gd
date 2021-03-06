extends Node2D
class_name Attacks

signal attack_started(actor_animation, weapon_animation)
signal finished()

export var can_loop := false
export var grounded := true
export var cancel_inputs : Dictionary

enum State { NOT_READY, LISTENING, REGISTERED_ATTACK, REGISTERED_CANCEL }
var state = State.LISTENING
var _ready_for_next_attack := false
var _can_cancel_animation := false # Should be used to transition out of weapon
var current_attack : Attack
var current_index := 0
var input : String
var cancel_input : String


func can_register_input() -> void:
	state = State.LISTENING

func disable_register_input() -> void:
	state = State.NOT_READY

func can_cancel_animation() -> void:
	_can_cancel_animation = true

func can_attack() -> void:
	_ready_for_next_attack = true


func _ready() -> void:
	set_physics_process(false)
	for attack in get_children():
		attack.connect("attack_started", self, "_attack_started")


func enter(args := {}) -> void:
	set_physics_process(true)
	reset()
	attack(args)
	

func exit() -> void:
	set_physics_process(false)
	if current_attack: # Prevents crashing if you try to spam different weapons
		current_attack.exit()
		current_attack = null


func reset() -> void:
	current_index = 0


func _physics_process(delta : float) -> void:
	if owner.paused:
		return
	
	for cancel_input_key in cancel_inputs.keys():
		if input == cancel_input_key:
			continue
		if owner.is_in_group("players") and Input.is_action_just_pressed(cancel_input_key):
			register_cancel(cancel_input_key)
			break

	match(state):
		State.NOT_READY:
			pass # Do nothing
		State.LISTENING:
			if not owner.input_enabled:
				return
			if Input.is_action_just_pressed(input):
				register_attack()
				return
		State.REGISTERED_ATTACK:
			if grounded and not owner.is_on_floor():
				return
			if _ready_for_next_attack and current_index < get_child_count():
				attack()
		State.REGISTERED_CANCEL:
			if _can_cancel_animation:
				var args = {}
				if current_attack:
					args = current_attack.get_exit_args()
				var state = cancel_inputs[cancel_input]
				if owner.state_machine.has_state(state):
					emit_signal("finished", state, args)


func attack(args := {}):
	state = State.NOT_READY
	_ready_for_next_attack = false
	_can_cancel_animation = false
	
	if current_attack:
		var exit_args = current_attack.get_exit_args()
		for key in exit_args.keys():
			args[key] = exit_args[key]
		current_attack.exit()
	
	current_attack = get_child(current_index)
	current_attack.enter(args)
	
	current_index += 1
	if current_index >= get_child_count() and can_loop:
		reset()


func register_cancel(input_key) -> void:
	cancel_input = input_key
	state = State.REGISTERED_CANCEL

func register_attack() -> void:
	state = State.REGISTERED_ATTACK


func _attack_started(actor_animation, weapon_animation) -> void:
	emit_signal("attack_started", actor_animation, weapon_animation)


func _attack_finished(next_state:="", args:={}):
	emit_signal("finished", next_state, args)


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "SETUP":
		return
	emit_signal("finished", "", current_attack.get_exit_args())


func get_exit_args() -> Dictionary:
	var args = {}
	if current_attack:
		args = current_attack.get_exit_args()
	return args


func pause() -> void:
	if current_attack:
		current_attack.pause()

func unpause() -> void:
	if current_attack:
		current_attack.unpause()

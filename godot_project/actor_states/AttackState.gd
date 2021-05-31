extends State
class_name AttackState

signal attack_started
signal not_ready
signal icon_set(icon)
signal attack_finished
signal attack_connected(parameters)

enum State { LISTENING, REGISTERED }

export(Array, PackedScene) var weapons : Array
export var input : String = ""
export var next_state : String = ""
export var initialize_on_start := true
export var stagger := true
export var active_after_exit := false

var weapon
var icon : Texture
var combo_ready : bool = false
var active := false


func _ready() -> void:
	if initialize_on_start:
		call_deferred("set_levelled_weapon") # Call deferred so state machine has chance to set attack state's owner


func set_levelled_weapon() -> void:
	set_weapon(weapons[0])


func set_weapon(weapon_scene : PackedScene) -> void:
	var new_weapon = weapon_scene.instance()
	assert (new_weapon is Weapon)
	if weapon:
		weapon.queue_free()
	weapon = new_weapon
	
	weapon.set_friendly_teams([owner.team])
	weapon.connect("attack_started", self, "attack_started")
	weapon.connect("not_ready", self, "not_ready")
	weapon.connect("finished", self, "weapon_finished")
	weapon.connect("attack_connected", self, "attack_connected")
	set_input_key(input)
	owner.add_weapon(weapon)
	weapon.set_owner(owner)
	weapon.active_after_exit = active_after_exit
	
	icon = weapon.icon
	call_deferred("emit_signal", "icon_set", icon)


func set_input_key(key : String) -> void:
	input = key
	weapon.set_input_key(input)


func enter(args := {}) -> void:
	.enter(args)
	if not initialize_on_start and not weapon:
		set_levelled_weapon()
	
	if weapon.attacks.grounded and not owner.is_on_floor():
		finished(next_state, args)
		return
	if weapon.cooldown_timer.time_left > 0 or weapon.gcd_timer.time_left > 0:
		not_ready()
		return
	
	if args.has("input_key"):
		set_input_key(args["input_key"])
	
	args["combo_ready"] = combo_ready
	deactivate_combo()
	weapon.enter(args)
	
	active = true


func exit() -> void:
	.exit()
	
	var rotation = 0.0 if owner.look_direction == Vector2.RIGHT else PI
	owner.set_rotation(rotation)
	
	active = false
	
	weapon.exit()


func attack_started(attack_animation : String) -> void:
	emit_signal("attack_started")
	owner.play_animation(attack_animation)
	if weapon.global_cooldown:
		for weapon_child in owner.weapons.get_children():
			if weapon_child.global_cooldown:
				weapon_child.start_global_cooldown()


func not_ready(args := {}) -> void:
	emit_signal("not_ready", args)
	print("Action not ready")


func weapon_finished(state_override := "", args := {}):
	emit_signal("attack_finished")
	if state_override == "":
		finished(next_state, args)
	else:
		finished(state_override, args)


func activate_combo() -> void:
	combo_ready = true


func deactivate_combo() -> void:
	combo_ready = false


func take_damage(args := {}):
	if stagger:
		finished("Stagger", args)


func pause() -> void:
	.pause()
	if weapon:
		weapon.pause()


func unpause() -> void:
	.unpause()
	if weapon:
		weapon.unpause()


func attack_connected(parameters) -> void:
	emit_signal("attack_connected", parameters)

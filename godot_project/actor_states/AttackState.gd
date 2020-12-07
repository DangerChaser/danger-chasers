extends State
class_name AttackState

signal attack_started
signal not_ready
signal icon_set(icon)
signal attack_finished

enum State { LISTENING, REGISTERED }

export(Array, int) var weapon_levels : Array
export(Array, PackedScene) var weapons : Array
export(String) var input : String = ""
export(String) var next_state : String = ""
export(bool) var initialize_on_start := true
export(bool) var stagger := true

var weapon
var icon : Texture
var combo_ready : bool = false
var active := false
var set_weapon_buffer := false
var set_weapon_buffer_level := 0


func _ready() -> void:
	assert (weapon_levels.size() == weapons.size())
	if initialize_on_start:
		call_deferred("set_levelled_weapon") # Call deferred so state machine has chance to set attack state's owner


func set_levelled_weapon() -> void:
	if active:
		set_weapon_buffer = true
		set_weapon_buffer_level = owner.stats.character_stats.level
		return
	
	var levelled_weapon = get_levelled_weapon(owner.stats.character_stats.level)
	set_weapon(levelled_weapon)


func set_weapon_through_stats(stats : CharacterStats) -> void:
	if active:
		set_weapon_buffer = true
		set_weapon_buffer_level = stats.level
		return
		
	var levelled_weapon = get_levelled_weapon(stats.level)
	set_weapon(levelled_weapon)


func get_levelled_weapon(level : int):
	var levelled_weapon = weapons[0]
	for i in range(weapon_levels.size()):
		var weapon_level = weapon_levels[i]
		if level >= weapon_level:
			levelled_weapon = weapons[i]
		else:
			break
	return levelled_weapon


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
	set_input_key(input)
	owner.add_weapon(weapon)
	weapon.set_owner(owner)
	
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
	
	weapon.exit()
	
	active = false
	if set_weapon_buffer:
		var levelled_weapon = get_levelled_weapon(set_weapon_buffer_level)
		call_deferred("set_weapon", levelled_weapon)


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

"""
Base class for Actor. Handles general movement.
"""
extends KinematicBody2DMirror
class_name Actor

signal died(actor)
signal died_no_arg
signal health_depleted(actor) # Emits as soon as enters Die state
signal health_depleted_no_arg # Emits as soon as enters Die state
signal initialized
signal weapon_added(weapon)

enum States { NORMAL, INVINCIBLE }
var state

export(Texture) var icon : Texture
export var team := "team_2"
export var pause_offscreen := true

onready var state_machine : StateMachine = $StateMachine
onready var weapons = pivot.get_node("Weapons")
onready var target = $Target
onready var stats = $Stats
onready var effects := $Effects
onready var buffs := effects.get_node("Buffs")
onready var debuffs := effects.get_node("Debuffs")
onready var miscellaneous_effects := effects.get_node("Miscellaneous")
onready var flash_timer : Timer = $FlashTimer
onready var flash_duration_timer : Timer = $FlashDuration
onready var hud := $ActorInterface

var character_stats setget set_stats, get_stats
var previous_position : Vector2
var last_move_direction : Vector2
var flashing := false
var initialize_on_ready := true # Set to false before adding to tree to delay initialization



func _ready():
	state = States.NORMAL
	pivot.connect("animation_finished", state_machine, "anim_finished")
	
	if state_machine.has_state("Stagger"):
		var stagger_state = state_machine.get_state("Stagger")
		stagger_state.connect("revenge_updated", hud, "revenge_updated")
	if pivot.has_node("Hurtbox"):
		var hurtbox = pivot.get_node("Hurtbox")
		hurtbox.connect("area_entered", self, "_on_Hurtbox_area_entered", [hurtbox])
	
	if initialize_on_ready:
		yield(get_tree().create_timer(0.01), "timeout")
		call_deferred("initialize", team)


func initialize(_team : String = "", initial_target=null) -> void:
	if _team:
		set_team(_team)
	
	for child in get_children():
		if child.has_method("initialize"):
			child.initialize()
	
	if initial_target:
		target.lock_on(initial_target)
	else:
		target.lock_on()
	
	emit_signal("initialized")


func set_team(_team : String) -> void:
	team = _team
	if not get_tree().get_nodes_in_group(team).has(self):
		add_to_group(team)
	for weapon in $Pivot/Weapons.get_children():
		weapon.set_friendly_teams([team])


func get_friendly_teams() -> Array:
	return [team]


func reset(target_global_position : Vector2) -> void:
	global_position = target_global_position
#	get_node("Pivot").play("SETUP")


func kill(args := {}) -> void:
	if state_machine.has_state("Die"):
		if pivot.has_node("Hurtbox"):
			pivot.get_node("Hurtbox").disable()
		if pivot.has_node("DamageSource"):
			pivot.get_node("DamageSource").disable()
		
		set_collision_layer_bit(PhysicsLayers.Actors, false)
		set_collision_layer_bit(PhysicsLayers.PlayerStoppers, false)
		set_collision_layer_bit(PhysicsLayers.EnemyStoppers, false)
		set_collision_layer_bit(PhysicsLayers.PassableActors, false)
		collider.set_deferred("disabled", true)
	
		state_machine.change_state("Die", args)
		
		emit_signal("health_depleted", self)
		emit_signal("health_depleted_no_arg")
		return


func die() -> void:
	emit_signal("died", self)
	emit_signal("died_no_arg")
	if has_node("CollisionBox"):
		get_node("CollisionBox").set_deferred("disabled", true)
	remove_from_group(team)
	


func set_stats(new_stats : Resource) -> void:
	stats.change_stats(new_stats)
	for state in state_machine.get_children():
		if state is AttackState:
			state.set_levelled_weapon()


func get_stats() -> CharacterStats:
	return $Stats.character_stats


func _on_Hurtbox_area_entered(area, hurtbox : Hurtbox):
	if state_machine.states_stack.size() == 0:
		return
	if state == States.INVINCIBLE or state_machine.get_current_state().name == "Die":
		return
	if area is DamageSource and not area.friendly_teams.has(team):
		area.confirm_hit(self, hurtbox)
		var direction
		if area.stagger_direction_while_right:
			direction = area.stagger_direction_while_right.normalized()
			if area.owner.pivot.global_scale.x < 0:
				direction.x *= -1
		else:
			direction = -(area.global_position - global_position).normalized()
		take_damage(area.damage, area.stagger_duration, area.stagger_force, area.stagger_mass, direction, area.revenge_value)


func take_damage(base_damage : int, duration := 0.0, force := 0.0, mass := 1.0, direction := Vector2(), revenge_value := 0.0):
	if buffs.has("Invincible"):
		return
	
	var damage = base_damage if not buffs.has("TakesNoDamage") else 0
	var died = stats.take_damage(damage)
	
	flash_duration_timer.start()
	flash_timer.start()
	flash()
	
	var args = { 
		"damage": damage,
		"duration" : duration,
		"force": force,
		"mass" : mass,
		"direction" : direction,
		"revenge_value" : revenge_value
	}
	
	if died:
		kill(args)
		return
	
	
	var current_state = state_machine.get_current_state()
	current_state.take_damage(args)


func _on_FlashTimer_timeout():
	if flashing:
		unflash()
	else:
		flash()

func flash() -> void:
	#To make sprite turn to white
	pivot.modulate = Color(10,10,10,10)
	flashing = true

func unflash() -> void:
	#and to return to normal color
	pivot.modulate = Color(1,1,1,1)
	flashing = false

func _on_FlashDuration_timeout():
	flash_timer.stop()
	unflash()

func _on_DropThroughArea_body_exited(body):
	if body == self:
		return
	stop_drop_through()


func stop_drop_through() -> void:
	set_collision_mask_bit(Utilities.DROP_THRU_BIT, true)


func add_weapon(weapon) -> void:
	$Pivot.get_node("Weapons").add_child(weapon)
	emit_signal("weapon_added", weapon)


func play_animation(anim_name : String) -> void:
	pivot.play(anim_name)


func face_actor(actor):
	var direction = global_position.direction_to(actor.global_position)
	var look_direction = Vector2.RIGHT if direction.x >= 0 else Vector2.LEFT
	update_look_direction(look_direction)


func pause():
	if pause_offscreen:
		state_machine.pause()
#		pivot.animation_player.stop(false)


func unpause():
	if pause_offscreen:
		state_machine.unpause()
#		pivot.animation_player.play()

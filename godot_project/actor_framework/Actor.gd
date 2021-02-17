"""
Base class for Actor. Handles general movement.
"""
extends MirrorBody2D
class_name Actor

signal died(actor)
signal died_no_arg
signal health_depleted(actor) # Emits as soon as enters Die state
signal health_depleted_no_arg # Emits as soon as enters Die state
signal initialized
signal weapon_added(weapon)

export var icon : Texture
export var team := "team_2"
export var pause_offscreen := true

onready var pivot : Pivot = $Pivot
onready var collider := $CollisionBox
onready var state_machine : StateMachine = $StateMachine
onready var weapons = pivot.get_node("Weapons")
onready var target = $Target
onready var stats = $Stats
onready var hud := $ActorInterface
onready var target_positions := $TargetPositions
onready var flash := $Flash

var initialize_on_ready := true # Set to false before adding to tree to delay initialization
var input_enabled := true
var paused := false


func _ready():
	pivot.connect("animation_finished", state_machine, "anim_finished")
	
	if state_machine.has_state("Stagger"):
		var stagger_state = state_machine.get_state("Stagger")
		stagger_state.connect("revenge_updated", hud, "revenge_updated")
	if pivot.has_node("Hurtbox"):
		var hurtbox = pivot.get_node("Hurtbox")
		hurtbox.connect("taken_damage", self, "_on_Hurtbox_area_entered")
	
	if initialize_on_ready:
		call_deferred("initialize", team)


func initialize(_team : String = "") -> void:
	if _team:
		set_team(_team)
	
	for child in get_children():
		if child.has_method("initialize"):
			child.initialize()
	
	emit_signal("initialized")


func set_team(_team : String) -> void:
	team = _team
	if not get_tree().get_nodes_in_group(team).has(self):
		add_to_group(team)
	for weapon in $Pivot/Weapons.get_children():
		weapon.set_friendly_teams(get_friendly_teams())
	target.lock_on()


func set_actor_collisions(value : bool) -> void:
	set_collision_layer_bit(PhysicsLayers.Actors, value)
	set_collision_layer_bit(PhysicsLayers.PlayerStoppers, value)
	set_collision_layer_bit(PhysicsLayers.EnemyStoppers, value)
	set_collision_layer_bit(PhysicsLayers.PassableActors, value)

func get_friendly_teams() -> Array:
	return [team]


func kill(args := {}) -> void:
	if state_machine.has_state("Die"):
		if pivot.has_node("Hurtbox"):
			pivot.get_node("Hurtbox").disable()
		if pivot.has_node("DamageSource"):
			pivot.get_node("DamageSource").disable()
		
		set_actor_collisions(false)
		
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


func _on_Hurtbox_area_entered(area, hurtbox : Hurtbox):
	if not state_machine.get_current_state() or state_machine.get_current_state().name == "Die":
		return
	
	if stats.buffs.has("Unhittable"):
		return
	
	if not area is DamageSource:
		return
	if area.friendly_teams.has(team) or area.hit_hurtboxes.has(hurtbox):
		return
	
	area.confirm_hit(self, hurtbox)
	var direction
	if area.stagger_direction_while_right:
		direction = area.stagger_direction_while_right.normalized()
		if area.owner.pivot.global_scale.x < 0:
			direction.x *= -1
	else:
		direction = -(area.global_position - global_position).normalized()
	
	take_damage(area.damage, area.stagger_duration, area.stagger_force, area.stagger_mass, direction, area.revenge_value, area.hitstun_duration)


func take_damage(base_damage : int, duration := 0.0, force := 0.0, mass := 1.0, direction := Vector2(), revenge_value := 0.0, hitstun_duration := 0.0):
	if stats.buffs.has("Invincible"):
		return
	
	var damage = base_damage if not stats.buffs.has("TakesNoDamage") else 0
	var died = stats.take_damage(damage)
	
	flash.start(duration)
	
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
	
	if stats.buffs.has("NoHitstun"):
		return
	if hitstun_duration > 0.0:
		pause()
		yield(get_tree().create_timer(hitstun_duration), "timeout")
		unpause()


func add_weapon(weapon) -> void:
	$Pivot.get_node("Weapons").add_child(weapon)
	emit_signal("weapon_added", weapon)


func play_animation(anim_name : String) -> void:
	pivot.play(anim_name)


func pause():
	if pause_offscreen:
		paused = true
		state_machine.pause()
		pivot.animation_player.stop(false)


func unpause():
	if pause_offscreen:
		paused = false
		state_machine.unpause()
		pivot.animation_player.play()


func enable_input() -> void:
	input_enabled = true

func disable_input() -> void:
	input_enabled = false


func change_state(next_state : String, args := {}) -> void:
	state_machine.change_state(next_state, args)

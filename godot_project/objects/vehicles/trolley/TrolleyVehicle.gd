extends Vehicle

onready var jump_registered_timer := $JumpRegisteredTimer
onready var damage_source : DamageSource = $Pivot/DamageSource

export var camera_offset := 200.0

var actor_original_collision_layer_mask
var original_offset : float


func enter(args := {}) -> void:
	.enter(args)
	actor_original_collision_layer_mask = owner.collision_mask
	owner.set_collision_mask_bit(PhysicsLayers.PlayerStoppers, false)
	
	damage_source.friendly_teams.append(owner.team)
	damage_source.collider.set_deferred("disabled", false)
	
	var camera_target_position = GameManager.get_player().get_node("CameraTargetPosition")
	original_offset = camera_target_position.offset
	camera_target_position.offset = camera_offset


func exit() -> void:
	owner.collision_mask = actor_original_collision_layer_mask
	owner.set_rotation(0)
	GameManager.get_player().get_node("CameraTargetPosition").offset = original_offset
	.exit()


func _physics_process(delta : float) -> void:
	if owner.is_on_wall():
		var args = {
			"direction" : Vector2(-1, -1).normalized(), 
			"force" : 6000, 
			"mass" : 16, 
			"duration" : 0.6,
			"animation" : "spin"
		}
		finished("Stagger", args)

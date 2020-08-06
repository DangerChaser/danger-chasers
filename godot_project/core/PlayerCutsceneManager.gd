extends Node2D
class_name PlayerCutsceneManager

var player
var movement_synced : bool = false


func _ready() -> void:
	set_physics_process(false)


func enable_and_sync_movement() -> void:
	enable()
	sync_movement()


func enable() -> void:
	PlayerManager.disable_input()
	hide_player_hud()

func sync_movement() -> void:
	set_physics_process(true)
	movement_synced = true

func disable() -> void:
	set_physics_process(false)
	movement_synced = false
	PlayerManager.enable_input()
	show_player_hud()

func _physics_process(delta):
	if movement_synced:
		player.global_position = lerp(player.global_position, global_position, 0.1)
		player.set_rotation(rotation)

func play_animation(anim_name : String) -> void:
	if not player:
		player = GameManager.get_player()
	player.play_animation(anim_name)


func show_player_hud() -> void:
	if not player:
		player = GameManager.get_player()
	player.player_hud.visible = true


func hide_player_hud() -> void:
	if not player:
		player = GameManager.get_player()
	player.player_hud.visible = false

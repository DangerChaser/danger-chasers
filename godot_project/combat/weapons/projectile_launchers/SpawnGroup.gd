extends Attack
class_name SpawnGroup

export(PackedScene) var muzzle_flash : PackedScene
export(float) var screen_shake_amplitude : float = 3.0
export(float) var screen_shake_duration : float = 0.3
export(float, EASE) var screen_shake_damp : float = 1.8

var friendly_teams : Array = []


func spawn(args:={}):
	for spawner in $Spawners.get_children():
		var projectile = spawner.spawn(GameManager.level.y_sort)
		projectile.set_friendly_teams(friendly_teams)
		if muzzle_flash:
			var new_muzzle_flash = muzzle_flash.instance()
			new_muzzle_flash.start(spawner.global_position, spawner.global_rotation, spawner.global_scale, GameManager.level)
	$Sfx.play()
	GameManager.current_camera.request_shake(screen_shake_amplitude, screen_shake_duration, screen_shake_damp)

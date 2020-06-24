extends Area2D

export(AudioStream) var music : AudioStream
export(bool) var disable_on_trigger := true
export var previous_song_fade_out_duration := 0.0
export var fade_out_pitch_up := false


func _on_MusicChangeTrigger_area_entered(area):
	change_music()
	if disable_on_trigger:
		$CollisionShape2D.set_deferred("disabled", true)


func change_music() -> void:
	GameManager.game.music_player.play_music(music, false, previous_song_fade_out_duration, fade_out_pitch_up)

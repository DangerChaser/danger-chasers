extends Button
class_name ButtonKey

export var key : String = ""
export var press_sfx : AudioStream

onready var audio_stream_player : AudioStreamPlayer = $AudioStreamPlayer


func _ready() -> void:
	if key:
		set_key(key)
	else:
		set_key(text)
	
	if press_sfx:
		audio_stream_player.stream = press_sfx


func set_key(new_key : String) -> void:
	if new_key:
		text = tr(new_key)


func _on_ButtonKey_pressed():
	audio_stream_player.play()

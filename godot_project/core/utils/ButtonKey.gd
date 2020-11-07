extends Button
class_name ButtonKey

export var key : String = ""
export var press_sfx : AudioStream
export var focus_enter_sfx : AudioStream

onready var press_sfx_player : AudioStreamPlayer = $PressSfxPlayer
onready var focus_entered_player : AudioStreamPlayer = $FocusEnteredPlayer


func _ready() -> void:
	if key:
		set_key(key)
	else:
		set_key(text)
	
	if press_sfx:
		press_sfx_player.stream = press_sfx
	if focus_enter_sfx:
		focus_entered_player.stream = focus_enter_sfx


func set_key(new_key : String) -> void:
	if new_key:
		text = tr(new_key)


func _on_ButtonKey_pressed():
	press_sfx_player.play()


func _on_ButtonKey_focus_entered():
	focus_entered_player.play()

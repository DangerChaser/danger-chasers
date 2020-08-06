extends Control
class_name AudioBusLevelController

export var bus_name := ""
onready var bus_index = AudioServer.get_bus_index(bus_name)
onready var texture_progress : TextureProgress = $TextureProgress
onready var sfx : AudioStreamPlayer = $Sfx

var enabled : bool

func _ready() -> void:
	disable()


func enable() -> void:
	var volume = db2linear(AudioServer.get_bus_volume_db(bus_index))
	texture_progress.value = volume * 100
	visible = true
	set_process_input(true)
	enabled = true


func disable() -> void:
	visible = false
	set_process_input(false)
	enabled = false


func toggle() -> void:
	if enabled:
		disable()
	else:
		enable()


func _input(event) -> void:
	if event.is_action_pressed("ui_up"):
		change_volume(0.1)
	if event.is_action_pressed("ui_down"):
		change_volume(-0.1)
	
	if event.is_action_pressed("ui_cancel"):
		disable()


func change_volume(delta : float) -> void:
	var volume = db2linear(AudioServer.get_bus_volume_db(bus_index))
	volume += delta
	volume = clamp(volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, linear2db(volume))
	print(volume)
	AudioServer.set_bus_mute(bus_index, volume == 0.0)
	
	texture_progress.value = volume * 100
	sfx.play()

extends Control
class_name AudioBusLevelController

signal enabled

export var bus_name := ""
export var focused_color : Color
export var unfocused_color : Color

onready var bus_index = AudioServer.get_bus_index(bus_name)
onready var texture_progress : TextureProgress = $TextureProgress
onready var sfx : AudioStreamPlayer = $Sfx

var enabled : bool

func _ready() -> void:
	update_progress()
	disable()


func enable() -> void:
	var volume = Settings.bus_volumes[bus_name]
	texture_progress.value = volume * 100
	visible = true
	set_process_input(true)
	enabled = true
	emit_signal("enabled")
	focus()


func disable() -> void:
	unfocus()
	set_process_input(false)
	enabled = false


func toggle() -> void:
	if enabled:
		disable()
	else:
		enable()


func _input(event) -> void:
	if event.is_action_pressed("ui_right"):
		change_volume(0.1)
	if event.is_action_pressed("ui_left"):
		change_volume(-0.1)
	
	if event.is_action_pressed("ui_cancel"):
		disable()


func change_volume(delta : float) -> void:
	Settings.change_volume(bus_name, delta)
	sfx.play()
	update_progress()


func update_progress() -> void:
	var volume = Settings.bus_volumes[bus_name]
	texture_progress.value = volume * 100


func unfocus():
	modulate = unfocused_color


func focus():
	modulate = focused_color

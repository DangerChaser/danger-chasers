extends Node

# Graphics settings
enum ScreenShakeIntensity { DISABLED, LOW, NORMAL, HIGH, EXTREME, VOMIT }
enum WindowModes { WINDOWED, FULL_SCREEN }

var screen_shake = ScreenShakeIntensity.NORMAL setget set_screen_shake
var frame_freeze_enabled := true setget set_frame_freeze
var window_mode = WindowModes.WINDOWED setget set_window_mode

# Audio settings
var bus_volumes := {
	"Master" : 1.0,
	"Music" : 0.8,
	"Sfx" : 1.0,
	"Ambience" : 0.5
}


func _ready() -> void:
	load_data()


func set_screen_shake(value) -> void:
	screen_shake = value
	save_data()

func set_frame_freeze(value) -> void:
	frame_freeze_enabled = value
	save_data()

func set_window_mode(value) -> void:
	window_mode = value
	_set_window_mode()
	save_data()


func _set_window_mode() -> void:
	if window_mode == WindowModes.WINDOWED:
		OS.window_fullscreen = false
	elif window_mode == WindowModes.FULL_SCREEN:
		OS.window_fullscreen = true


func change_volume(bus : String, delta : float) -> void:
	var bus_index = AudioServer.get_bus_index(bus)
	var volume = db2linear(AudioServer.get_bus_volume_db(bus_index))
	volume += delta
	set_volume(bus, volume)

func set_volume(bus: String, volume : float) -> void:
	var bus_index = AudioServer.get_bus_index(bus)
	volume = clamp(volume, 0.0, 1.0)
	AudioServer.set_bus_volume_db(bus_index, linear2db(volume))
	AudioServer.set_bus_mute(bus_index, volume == 0.0)
	bus_volumes[bus] = volume
	save_data()


func save_data() -> void:
	var file = File.new()
	var file_name = GameManager.USER_DIR + "settings.dat"
	var error = file.open(file_name, File.WRITE)
	if not error == OK:
		print_debug("Error opening " + file_name + ".")
		return
	
	var settings = {
		"graphics" : {
			"screen_shake" : screen_shake,
			"frame_freeze_enabled" : frame_freeze_enabled,
			"window_mode" : window_mode
		},
		"audio" : {
			"bus_volumes" : bus_volumes
		}
	}
	file.store_var(settings)
	file.close()


func load_data() -> void:
	var file = File.new()
	var file_name = GameManager.USER_DIR + "settings.dat"
	if not file.file_exists(file_name):
		print_debug("File " + file_name + " does not exist.")
		return
	
	var error = file.open(file_name, File.READ)
	if not error == OK:
		print_debug("Error opening " + file_name + ".")
		return
	
	var settings : Dictionary = file.get_var()
	bus_volumes = settings["audio"]["bus_volumes"]
	
	var graphics_settings = settings["graphics"]
	screen_shake = graphics_settings["screen_shake"]
	frame_freeze_enabled = graphics_settings["frame_freeze_enabled"]
	window_mode = graphics_settings["window_mode"]
	
	file.close()
	
	
	for volume in bus_volumes:
		set_volume(volume, bus_volumes[volume])
	_set_window_mode()

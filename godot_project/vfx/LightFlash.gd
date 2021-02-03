extends Light2D
class_name LightFlash

onready var max_energy := energy

export var duration := 1.0

func _ready() -> void:
	enabled = false


func start() -> void:
	enabled = true
	$Tween.interpolate_property(self, "energy", energy, 0.0, duration,Tween.TRANS_QUAD, Tween.EASE_OUT)
	$Tween.start()

extends Node2D

signal started(max_value)
signal ticked(value)
signal finished

export var max_value := 100
export var tick_value := 10
export var tick_rate := 1.0

onready var current_value := max_value

var active := false


func start() -> void:
	$Ticker.start()
	active = true
	emit_signal("started", max_value)

func _on_Ticker_timeout():
	current_value = max(0, current_value - tick_value)
	emit_signal("ticked", tick_value)
	if current_value == 0:
		$Ticker.stop()
		active = false
		emit_signal("finished")

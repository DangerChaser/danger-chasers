extends Node2D


signal turned_on
signal turned_off

export var disable_on_turn_on := false
var on : bool

func _ready():
	turn_off()


func turn_on() -> void:
	$TurnOn/CollisionShape2D.disabled = true
	$AnimationPlayer.play("turn_on")
	on = true
	emit_signal("turned_on")
	if not disable_on_turn_on:
		$TurnOff/CollisionShape2D.disabled = false


func turn_off() -> void:
	$TurnOff/CollisionShape2D.disabled = true
	$AnimationPlayer.play("turn_off")
	on = false
	emit_signal("turned_off")
	$TurnOn/CollisionShape2D.disabled = false

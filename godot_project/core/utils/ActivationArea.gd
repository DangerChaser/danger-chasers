extends Area2D
class_name ActivationArea

signal area_entered_no_area # Just used as a trigger when no need for area checking
signal area_exited_no_area # Just used as a trigger when no need for area checking

export(bool) var disable_on_trigger := false

func _ready() -> void:
	connect("area_entered", self, "_on_area_entered")
	connect("area_exited", self, "_on_area_exited")

func _on_area_entered(area : Area2D) -> void:
	emit_signal("area_entered_no_area")
	if disable_on_trigger:
		disable()


func _on_area_exited(area : Area2D) -> void:
	emit_signal("area_exited_no_area")


func enable() -> void:
	set_deferred("monitoring", true)
	set_deferred("monitorable", true)
	$CollisionShape2D.set_deferred("disabled", false)


func disable() -> void:
	set_deferred("monitoring", false)
	set_deferred("monitorable", false)
	$CollisionShape2D.set_deferred("disabled", true)

extends Control

signal start_finished
signal end_finished

const OFFSET : int = 50 # Used to "pad" out the bars
onready var tween : Tween = $Tween
onready var top_bar : = $Top
onready var bottom_bar : = $Bottom
onready var top_bar_original_position : Vector2 = top_bar.rect_position
onready var bottom_bar_original_position : Vector2 = bottom_bar.rect_position


func _ready() -> void:
	visible = false


func start(duration : float = 0.5, trans_type=Tween.TRANS_QUAD, ease_type=Tween.EASE_OUT) -> void:
	visible = true
	top_bar.rect_position = Vector2(-top_bar.rect_size.x - OFFSET, -OFFSET)
	bottom_bar.rect_position = Vector2(bottom_bar.rect_size.x + OFFSET, get_viewport().size.y + OFFSET)
	var top_final_position = top_bar_original_position
	var bottom_final_position = bottom_bar_original_position
	tween.interpolate_property(top_bar, "rect_position", null, top_final_position, duration, trans_type, ease_type)
	tween.interpolate_property(bottom_bar, "rect_position", null, bottom_final_position, duration, trans_type, ease_type)
	
	tween.start()
	yield(tween, "tween_completed")
	emit_signal("start_finished")


func end(duration : float = 0.5, trans_type=Tween.TRANS_QUAD, ease_type=Tween.EASE_OUT) -> void:
	var top_final_position = Vector2(top_bar.rect_size.x + OFFSET, -OFFSET)
	var bottom_final_position = Vector2(-bottom_bar.rect_size.x - OFFSET, get_viewport().size.y + OFFSET)
	tween.interpolate_property(top_bar, "rect_position", null, top_final_position, duration, trans_type, ease_type)
	tween.interpolate_property(bottom_bar, "rect_position", null, bottom_final_position, duration, trans_type, ease_type)
	tween.start()
	yield(tween, "tween_completed")
	visible = false
	emit_signal("end_finished")
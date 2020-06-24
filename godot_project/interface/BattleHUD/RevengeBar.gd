extends Bar

onready var tween : Tween = $Tween
onready var timer : Timer = $Timer


func _ready() -> void:
	hide_bar()

func set_bar(new_value : float, old_value : float, max_value : float) -> void:
	texture_progress.max_value = max_value
	texture_progress.value = old_value
	
	visible = true
	tween.interpolate_property(texture_progress, "value", old_value, new_value, 0.1, Tween.TRANS_ELASTIC, Tween.EASE_IN)
	tween.start()
	
	timer.start()


func hide_bar() -> void:
	visible = false


func _on_Timer_timeout():
	hide_bar()

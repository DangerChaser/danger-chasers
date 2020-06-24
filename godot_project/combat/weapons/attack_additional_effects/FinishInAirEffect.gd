extends AttackAdditionalEffect
class_name FinishInAirEffect

export(float) var wait_time := 0.1
var timer : Timer

func _ready() -> void:
	timer = Timer.new()
	timer.wait_time = wait_time
	timer.one_shot = true
	add_child(timer)
	timer.connect("timeout", self, "_on_timeout")


func _physics_process(delta:float) -> void:
	if owner.is_on_floor():
		if not timer.is_stopped():
			timer.stop()
	else:
		if timer.is_stopped():
			timer.start()


func _on_timeout() -> void:
	emit_signal("finished")
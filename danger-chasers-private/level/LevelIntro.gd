extends Container
class_name LevelIntro

signal finished

export(String) var level_name_key = ""
export(float) var typweriter_delay = 0.01
export(float) var finish_delay = 0.5
export(float) var hang_delay = 0.2


func start():
	visible = true
	if level_name_key:
		$TypewriterLabel.print_key("level_names", level_name_key, typweriter_delay)
		return self
	else:
		finished()


func finished() -> void:
	yield(get_tree().create_timer(finish_delay), "timeout")
	emit_signal("finished")
	yield(get_tree().create_timer(hang_delay), "timeout")
	visible = false

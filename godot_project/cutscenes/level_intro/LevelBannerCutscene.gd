extends Cutscene


func set_level(level_name_key : String) -> void:
	$CanvasLayer/Control/LevelNameLabel.set_key(level_name_key)

func set_act(number : int) -> void:
	$CanvasLayer/Control/ActLabel.set_key("ACT")
	$CanvasLayer/Control/ActLabel.text += " " + str(number)

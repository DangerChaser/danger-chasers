extends CanvasLayer


func _ready():
	var actor = get_parent()
	actor.connect("initialized", $BattleHUD, "initialize", [actor, actor.icon])
	$BattleHUD.visible = false

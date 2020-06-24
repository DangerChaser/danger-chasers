extends InteractionArea

export var loot_table : String
export var pickup : bool = false

onready var loot_panel := $LootPanel


func _ready():
	loot_panel.enable(loot_table)
	loot_panel.hide()

func interact() -> void:
	.interact()
	loot_panel.loot(0)
	visible = false
	#queue_free()


func _on_area_entered(area : Area2D) -> void:
	._on_area_entered(area)
	triggered_area = area
	if pickup:
		interact()
	else:
		enable_interaction()
		loot_panel.show()


func _on_area_exited(area : Area2D) -> void:
	._on_area_exited(area)
	if area == triggered_area:
		loot_panel.hide()

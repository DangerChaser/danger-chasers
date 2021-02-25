extends InteractionArea

export var item_name := ""
export var pickup = false


func interact() -> void:
	.interact()
	InventoryData.add(item_name)
	visible = false
	#queue_free()


func _on_area_entered(area : Area2D) -> void:
	._on_area_entered(area)
	triggered_area = area
	if pickup:
		interact()
	else:
		enable_interaction()


func _on_Sfx_finished():
	queue_free()

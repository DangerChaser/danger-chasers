extends Control

onready var health_bar := $HealthBar
onready var mana_bar := $ManaBar
onready var player_icon := $PlayerIcon/Icon
onready var message_labels := {
	"action_not_ready" : $CenterTopMessages/ActionNotReady
}
onready var hotbar := $Hotbar

func _ready() -> void:
	for label in message_labels.values():
		label.visible = false
	for hotbar_slot in hotbar.get_children():
		hotbar_slot.visible = false


func initialize(player : Actor, icon : Texture) -> void:
	set_player_icon(icon)
	health_bar.initialize(player)
	visible = true
#	player.character_stats.connect("mana_changed", self, "set_mana_bar")


func set_player_icon(new_icon : Texture) -> void:
	player_icon.texture = new_icon


#func set_mana_bar(new_value : int, old_value : int, max_value : int) -> void:
#	mana_bar.get_node("TextureProgress").value = float(new_value) / max_value


func display_message(message : String, wait_time : float) -> void:
	message_labels[message].visible = true
	yield(get_tree().create_timer(wait_time), "timeout")
	message_labels[message].visible = false


func set_hotbars(job : Job) -> void:
	for i in range(job.get_child_count()):
		var skill = job.get_child(i)
		var hotbar_slot = $Hotbar.get_child(i)
		hotbar_slot.set_skill(skill)


func open_health_vial(max_value):
	$HealthVials.open(max_value)


func _on_HealthVials_ticked(value):
	$HealthVials.tick(value)


func _on_HealthVials_vial_finished():
	$HealthVials.finished()


func _on_HealthVials_vial_initialized():
	$HealthVials.vial_initialized()

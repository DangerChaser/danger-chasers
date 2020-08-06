extends Control

onready var background : TextureRect = $Icon/Background
onready var icon : TextureProgress = $Icon/Icon
onready var overlay : TextureRect = $Icon/Overlay
onready var cooldown_label : Label = $Icon/CooldownLabel
onready var key_label : Label = $KeyLabel


var skill

func _ready() -> void:
	if not skill:
		visible = false


func set_skill(new_skill) -> void:
	skill = new_skill
	set_cooldown_label(0)
	set_icon(skill.icon)
	key_label.text = InputMap.get_action_list(skill.input)[0].as_text()
	set_deferred("visible", true)


func _process(delta : float) -> void:
	if not skill:
		return
	var cd_left = skill.weapon.cd_timer.time_left
	set_cooldown_label(ceil(cd_left))
	var gcd_left = skill.weapon.gcd_timer.time_left
	icon.value = (1 - gcd_left) / GameManager.global_cooldown * 100
	if cd_left <= 0 and gcd_left <= 0:
		icon.modulate = Color(1.0, 1.0, 1.0, 1.0)
	else:
		icon.modulate = Color(0.5, 0.5, 0.5, 1.0)


func set_icon(_icon : Texture) -> void:
	icon.texture_progress = _icon


func set_key(key : String) -> void:
	key_label.text = key


func set_cooldown_label(value) -> void:
	cooldown_label.text = str(value)
	if value <= 0:
		cooldown_label.visible = false
	else:
		cooldown_label.visible = true

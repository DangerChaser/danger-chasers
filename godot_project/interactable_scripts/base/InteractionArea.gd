extends ActivationArea
class_name InteractionArea

signal interacted
signal interacted_with_actor(actor)
var interactable_script : InteractableScript

onready var pin : Control = $Pin
onready var button : Button = $Pin/Button
onready var pin_offset : Vector2 = pin.rect_position
onready var collider : CollisionShape2D = $CollisionShape2D

export var keep_focus_on_interact := false
export var actor_must_be_on_floor := false

var triggered_area : Area2D


func _ready():
	if has_node("InteractableScript"):
		interactable_script = $InteractableScript
	hide_key()
	set_process_input(false)


func _on_area_entered(area : Area2D) -> void:
	emit_signal("area_entered_no_area")
	triggered_area = area
	enable_interaction()

func _on_area_exited(area : Area2D) -> void:
	._on_area_exited(area)
	
	if area == triggered_area:
		disable_interaction()
	
	triggered_area = null


func enable_interaction() -> void:
	pin.get_parent().remove_child(pin)
	GameManager.level.y_sort.add_child(pin)
	pin.rect_scale = Vector2(1, 1) / pin.get_parent().scale
	set_process(true)
	
	button.enable()
	set_process_input(true)
	
	show_key()


func disable_interaction() -> void:
	hide_key()
	button.disable()
	set_process_input(false)
	set_process(false)


func _process(delta):
	pin.rect_global_position = global_position + pin_offset


func _physics_process(delta):
	if not actor_must_be_on_floor:
		return
	
	if not triggered_area:
		return
	
	var actor : Actor = triggered_area.owner
	if not actor.is_on_floor():
		disable_interaction()
	else:
		enable_interaction()


func show_key() -> void:
	pin.get_node("KeyLabel").text = InputMap.get_action_list("interact")[0].as_text()
	pin.visible = true


func hide_key():
	pin.visible = false


func _input(event):
	if event.is_action_pressed("interact"):
		interact()

func interact() -> void:
	var actor
	if triggered_area:
		actor = triggered_area.owner
		emit_signal("interacted_with_actor", actor)
	if has_node("InteractableScript"):
		$InteractableScript.interact(actor)
	$Sfx.play()
	if not keep_focus_on_interact:
		hide_key()
		set_process_input(false)
	emit_signal("interacted")
	
	if disable_on_trigger:
		disable()



func _on_Button_button_down():
	interact()

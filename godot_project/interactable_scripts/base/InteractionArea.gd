extends ActivationArea
class_name InteractionArea

signal locked
signal unlocked
signal interacted_locked
signal interacted
signal interacted_with_actor(actor)
var interactable_script : InteractableScript

onready var pin : Control = $Pin
onready var button : Button = $Pin/Button
onready var collider : CollisionShape2D = $CollisionShape2D

export var is_locked := false
export var keep_focus_on_interact := false
export var actor_must_be_on_floor := false

var triggered_area : Area2D


func _ready():
	if is_locked:
		lock()
	else:
		unlock()
	
	if has_node("InteractableScript"):
		interactable_script = $InteractableScript
	pin.disable()
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
	pin.enable(self, InputMap.get_action_list("interact")[0].as_text())
	button.enable()
	set_process_input(true)

func disable_interaction() -> void:
	pin.disable()
	button.disable()
	set_process_input(false)


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


func _input(event):
	if event.is_action_pressed("interact"):
		interact()

func _on_Button_button_down():
	interact()

func interact() -> void:
	if is_locked:
		emit_signal("interacted_locked")
		return
	
	var actor
	if triggered_area:
		actor = triggered_area.owner
		emit_signal("interacted_with_actor", actor)
	if has_node("InteractableScript"):
		$InteractableScript.interact(actor)
	$Sfx.play()
	if not keep_focus_on_interact:
		pin.disable()
		set_process_input(false)
	emit_signal("interacted")
	
	if disable_on_trigger:
		disable()


func lock() -> void:
	is_locked = true
	emit_signal("locked")

func unlock() -> void:
	is_locked = false
	emit_signal("unlocked")

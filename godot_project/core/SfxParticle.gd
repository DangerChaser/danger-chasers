extends Node2D
class_name SfxParticle

export(bool) var can_rotate : bool = true
export var queue_free_after_timer := true

onready var particles := $Pivot.get_children()
onready var timer := Timer.new()


func _ready():
	if queue_free_after_timer:
		timer.connect("timeout", self, "queue_free")
		var max_lifetime = 0.0
		for particle in $Pivot.get_children():
			max_lifetime = max(max_lifetime, particle.lifetime)
		timer.wait_time = max_lifetime + 1.0
		add_child(timer)


func start(_global_position := Vector2(), _global_rot_rad =null, _scale := Vector2(), parent=null, direction := Vector2()):
	if parent:
		if get_parent():
			get_parent().remove_child(self)
		parent.add_child(self)
	elif get_parent():
		owner = get_parent().owner
	else:
		GameManager.game.add_child(self)
	
	if queue_free_after_timer:
		timer.start()
	
	if _global_position:
		global_position = _global_position
	if _scale:
		scale = _scale
	if can_rotate and _global_rot_rad:
		global_rotation = _global_rot_rad
	
	$Sfx.play()
	for particle in particles:
		if direction:
			particle.process_material.direction = Vector3(direction.x, direction.y, 0)
		particle.emitting = true


func stop() -> void:
	$Sfx.stop()
	disable_emitting()


func play():
	start(global_position, global_rotation, global_scale, get_parent())


func enable_emitting() -> void:
	for particle in particles:
		particle.emitting = true


func disable_emitting() -> void:
	for particle in particles:
		particle.emitting = false

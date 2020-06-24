extends Node2D

export(NodePath) var sprite_path : NodePath

onready var base_sprite = get_node(sprite_path)

var sprite_transforms : Dictionary = {}
var enabled := false

func _ready() -> void:
	set_physics_process(false)

func start() -> void:
	$Timer.start()
	set_physics_process(true)

func stop() -> void:
	$Timer.stop()
	set_physics_process(false)


func _physics_process(delta) -> void:
	for sprite in sprite_transforms.keys():
		sprite.global_transform = sprite_transforms[sprite]

func _on_Timer_timeout() -> void:
	update_sprite()

func update_sprite() -> void:
	# Bottom sprite in tree is displayed above sprites above
	var last_sprite = $Sprites.get_child(0)
	$Sprites.move_child(last_sprite, $Sprites.get_child_count())
	sprite_transforms[last_sprite] = base_sprite.global_transform
	
	last_sprite.texture = base_sprite.texture
	last_sprite.offset = base_sprite.offset
	last_sprite.vframes = base_sprite.vframes
	last_sprite.hframes = base_sprite.hframes
	last_sprite.frame = base_sprite.frame
	last_sprite.flip_h = base_sprite.flip_h
	
	if not enabled:
		last_sprite.visible = false

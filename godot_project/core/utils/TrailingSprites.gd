extends Node2D

export(NodePath) var sprite_path : NodePath
export(Array, String) var active_animations : Array = ["quick_attack"]

onready var base_sprite = get_node(sprite_path)

var sprite_transforms : Dictionary = {}
var enabled := false
var active_sprites : int = 0


func _ready() -> void:
	set_process(false)
	if not enabled:
		for sprite in $Sprites.get_children():
			sprite.visible = false

func start(animation : String = "") -> void:
	if not animation in active_animations:
		return
	
	$Timer.start()
	enabled = true
	set_process(true)

# new_animation is a dummy variable
func stop(animation : String = "", new_animation = "") -> void:
	if not animation in active_animations:
		return
	
	enabled = false
	set_process(false)


func _process(delta) -> void:
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
	last_sprite.normal_map = base_sprite.normal_map
	
	if enabled and active_sprites < $Sprites.get_child_count():
		last_sprite.visible = true
		active_sprites += 1
	elif not enabled:
		last_sprite.visible = false
		active_sprites -= 1
		if active_sprites <= 0:
			$Timer.stop()

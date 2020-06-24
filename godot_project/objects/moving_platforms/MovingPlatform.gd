tool
extends KinematicBody2D
class_name MovingPlatform

signal started

onready var animation_player: AnimationPlayer = $AnimationPlayer
onready var wait_timer: Timer = $Timer
var waypoints

export var editor_process: = false setget set_editor_process
export var speed := 400.0

export var waypoints_path: = NodePath()
export var loop := true
export var autostart := true

var target_position := Vector2()


func _ready() -> void:
	animation_player.play("SETUP")
	
	if has_node("ActorSensor"):
		get_node("ActorSensor").connect("triggered", self, "start")
		set_physics_process(false)
	
	if waypoints_path:
		waypoints = get_node(waypoints_path)
		waypoints.reset()
		global_position = waypoints.get_start_position()
		target_position = waypoints.get_next_point_position()
		if not autostart:
			set_physics_process(false)
	else:
		set_physics_process(false)


func start() -> void:
	set_physics_process(true)
	emit_signal("started")

func enable() -> void:
	get_node("Sprite").visible = true
	get_node("CollisionShape2D").disabled = false

func disable() -> void:
	get_node("Sprite").visible = false
	get_node("CollisionShape2D").disabled = true


func _physics_process(delta : float) -> void:
	if not waypoints_path:
		set_physics_process(false)
		return
	
	var direction := (target_position - global_position).normalized()
	var motion := direction * speed * delta
	var distance_to_target := global_position.distance_to(target_position)
	
	if motion.length() > distance_to_target:
		global_position = target_position
		target_position = waypoints.get_next_point_position()
		set_physics_process(false)
		if not loop and waypoints._active_point_index == 0:
			return
		$Timer.start()
	else:
		global_position += motion


func _on_Timer_timeout():
	set_physics_process(true)


func set_editor_process(value : bool) -> void:
	editor_process = value
	
	if not Engine.editor_hint:
		return
	if not waypoints_path:
		set_physics_process(false)
		return
	waypoints = get_node(waypoints_path)
	waypoints.reset()
	global_position = waypoints.get_start_position()
	target_position = waypoints.get_next_point_position()
	set_physics_process(value)
	$Timer.stop()


func move() -> void:
	animation_player.play("move")

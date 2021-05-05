extends Node2D
class_name Effect

signal started(effect_name)
signal finished(effect_name)

export(float) var base_duration := 5.0
export(bool) var lasts_forever := false

onready var timer := Timer.new()


func _ready() -> void:
	timer.wait_time = base_duration
	timer.one_shot = true
	timer.connect("timeout", self, "_on_timeout")
	add_child(timer)
	set_physics_process(false)
	initialize()


func initialize(args:={}) -> void: # Do not override this function, override _initialize() instead
	call_deferred("_initialize", args)


func _initialize(args:={}) -> void: # Called with call_deferred to avoid _ready() timing issues
	if args.has("duration"):
		timer.wait_time = args["duration"]
	
	set_physics_process(true)
	emit_signal("started", name)
	
	if lasts_forever:
		return
	timer.start()


func _on_timeout() -> void:
	emit_signal("finished", name)
	queue_free()

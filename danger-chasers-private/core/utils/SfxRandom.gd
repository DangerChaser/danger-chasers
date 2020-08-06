extends AudioStreamPlayer2D
class_name AudioStreamPlayer2DRandom

export(Array, AudioStream) var sfx_list : Array = []
export(float) var random_pitch_low := 1.0
export(float) var random_pitch_high := 1.0
export(float) var decay := 0.0

onready var tween := Tween.new()
var original_volume : float

func _ready() -> void:
	original_volume = volume_db
	tween.connect("tween_completed", self, "_on_tween_completed")
	add_child(tween)


func play(var from_position=0.0):
	tween.stop(self, "volume_db")
	volume_db = original_volume
	
	randomize()
	if sfx_list.size() > 0:
		var random_index = randi() % sfx_list.size()
		stream = sfx_list[random_index]
	pitch_scale = rand_range(random_pitch_low, random_pitch_high)
	
	.play(from_position)


func stop():
	if decay > 0.0:
		tween.interpolate_property(self, "volume_db", volume_db, -80.0, decay, Tween.TRANS_LINEAR, Tween.EASE_IN)
		tween.start()
	else:
		.stop()

func _on_tween_completed(object : Object, key : NodePath) -> void:
	if object == self and key == "volume_db":
		.stop()

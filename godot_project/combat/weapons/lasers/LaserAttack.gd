extends Attack


onready var lasers : Array = $Lasers.get_children()


func _ready() -> void:
	for laser in lasers:
		laser.disable()


func start() -> void:
	for laser in lasers:
		laser.enable()

func exit() -> void:
	.exit()
	for laser in lasers:
		laser.disable()

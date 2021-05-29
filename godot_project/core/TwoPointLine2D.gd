extends Line2D


export var target_0 : NodePath
export var target_1 : NodePath

var node_0
var node_1

func _ready():
	node_0 = get_node(target_0)
	node_1 = get_node(target_1)
	if not node_0 or not node_1:
		set_process(false)


func _process(delta):
	var average_position = (node_1.position + node_0.position) / 2
	position = average_position
	points[0] = node_0.position - average_position
	points[1] = node_1.position - average_position

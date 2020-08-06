extends State


func enter(args:={}):
	if args.has("node"):
		var node = args["node"]
		node.connect("finished", self, "finished")
		add_child(node)
		node.set_owner(owner)
		node.enter(args)
	else:
		emit_signal("finished", "Idle")


func exit():
	for child in get_children():
		child.exit()
		child.queue_free()


func finished(next_state := "Idle", args := {}) -> void:
	emit_signal("finished", next_state, args)

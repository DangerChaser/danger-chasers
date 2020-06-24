extends State
class_name PassArgs

export(String) var next_state := ""
export(Dictionary) var args := {}


func enter(_args := {}) -> void:
	.enter(args)
	for key in _args.keys():
		args[key] = _args[key]
	call_deferred("call_deferred", "call_deferred", "emit_signal", "finished", next_state, args)
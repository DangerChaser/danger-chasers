extends Node


func read_json(file_path : String):
	var file = File.new()
	file.open(file_path, File.READ)
	var json = JSON.parse(file.get_as_text())
	file.close()
	return json.result

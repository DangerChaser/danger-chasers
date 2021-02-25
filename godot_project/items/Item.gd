extends Node
class_name Item

var description : String
var icon : Texture
var type : String
var subtype : String
var stack : bool
var rarity : String
var quality : String
var level : int


func clone():
	var new_item = duplicate()
	new_item.name = name
	new_item.description = description
	new_item.icon = icon
	new_item.type = type
	new_item.subtype = subtype
	new_item.stack = stack
	new_item.rarity = rarity
	new_item.quality = quality
	new_item.level = level
	return new_item

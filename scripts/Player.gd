extends "res://scripts/UnitCard.gd"

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")

func _ready():
	super()
	
	add_to_group("PlayerUnits")
		
func _get_drag_data(_pos):
	var dataOut = {}
	
	dataOut["origin_node"] = get_parent()
	dataOut["origin_child"] = self
	dataOut["origin_data"] = data
		
	var dragPreview = DRAGPREVIEW.instantiate()
	dragPreview.set_texture(load(data["image"]))
	add_child(dragPreview)
	
	return dataOut

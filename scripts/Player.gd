extends "res://scripts/UnitCard.gd"

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var LOCKED = preload("res://scene/locked.tscn")

func _ready():
	super()
	
	add_to_group("PlayerUnits")
		
func _get_drag_data(_pos):
	var dataOut = {}
	
	if not get_parent().is_disabled():
		dataOut["origin_node"] = get_parent()
		dataOut["origin_child"] = self
		dataOut["origin_data"] = data
			
		var dragPreview = DRAGPREVIEW.instantiate()
		dragPreview.set_texture(load(data["image"]))
		add_child(dragPreview)
	
	return dataOut

func lock_player():
	if not has_node("../Locked"):
		get_parent().set_disabled(true)
		var locked = LOCKED.instantiate()
		get_parent().add_child(locked)

extends "res://scripts/UnitCard.gd"

@export var player_id: String

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")

func init(pData):
	data = pData
	texture_normal = load(data["image"])

func _ready():
	super()
	
	add_to_group("PlayerUnits")
	
	if not data:
		var player_list_path = ("res://scripts/PlayerList.json")
		data = _load_json_file(player_list_path)[player_id]
		set_texture_normal(load(data["image"]))
		
func _get_drag_data(_pos):
	var dataOut = {}
	
	dataOut["origin_node"] = get_parent()
	dataOut["origin_child"] = self
	dataOut["origin_data"] = data
		
	var dragPreview = DRAGPREVIEW.instantiate()
	dragPreview.set_texture(load(data["image"]))
	add_child(dragPreview)
	
	return dataOut

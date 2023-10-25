extends "res://scripts/UnitCard.gd"

@export var player_id: String

func init(pData):
	data = pData
	texture_normal = load(data["image"])

func _ready():
	super()
	
	if not data:
		var player_list_path = ("res://scripts/PlayerList.json")
		data = _load_json_file(player_list_path)[player_id]
		texture_normal = load(data["image"])

func get_data():
	return data

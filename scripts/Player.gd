extends "res://scripts/UnitCard.gd"

@export var player_id: String

func _ready():
	super()
	
	var player_list_path = ("res://scripts/PlayerList.json")
	data = _load_json_file(player_list_path)[player_id]
	texture_normal = load(data["image"])


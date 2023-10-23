extends "res://scripts/UnitCard.gd"

@export var player_id: String

func _ready():
	super()
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	var player_list_path = ("res://scripts/PlayerList.json")
	data = _load_json_file(player_list_path)[player_id]
	texture_normal = load(data["image"])


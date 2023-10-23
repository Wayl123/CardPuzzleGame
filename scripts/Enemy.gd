extends "res://scripts/UnitCard.gd"

@export var enemy_id: String

func _ready():
	super()
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	var enemy_list_path = ("res://scripts/EnemyList.json")
	data = _load_json_file(enemy_list_path)[enemy_id]
	texture_normal = load(data["image"])

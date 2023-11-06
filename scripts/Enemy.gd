extends "res://scripts/UnitCard.gd"

@export var enemy_id: String

func _ready():
	super()
	
	var enemy_list_path = ("res://scripts/EnemyList.json")
	data = _load_json_file(enemy_list_path)[enemy_id]
	set_texture_normal(load(data["image"]))

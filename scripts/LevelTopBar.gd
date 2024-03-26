extends "res://scripts/TopBar.gd"

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var infoGold = %Gold

var data = {
	"gold": 0,
	"honour": 0,
	"research": 0,
	"soul": 0,
	"scrap": 0
}

func _ready():
	super()
	
	_change_display()
	_init_data()

func _init_data() -> void:
	var startingItems = globalData.get_current_level_starting_items()
	change_gold(startingItems["gold"])
	
	for deck in globalData.get_used_deck_data():
		var items = deck["items"]
		change_gold(items["gold"])
		
func _change_display() -> void:
	infoGold.set_text(str("Gold: ", data["gold"]))
	
func get_gold() -> float:
	return data["gold"]

func change_gold(pChange : float) -> void:
	data["gold"] += pChange
	
	_change_display()
	
func get_data() -> Dictionary:
	return data

extends TextureRect

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var infoGold = %Gold
@onready var menu = %Menu

var data = {
	"gold": 0,
	"honour": 0,
	"research": 0,
	"soul": 0,
	"scrap": 0
}

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	_change_display()
	_init_data()

func _on_viewport_size_changed() -> void:
	_update_size()

func _update_size() -> void:
	var viewportSize = get_viewport().size
	set_size(Vector2(viewportSize.x, 32))
	
	menu.set_position(Vector2(viewportSize.x - 32, 0))
	
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

extends TextureRect

@onready var infoGold = %Gold

var data = {
	"gold": 10,
	"honour": 0,
	"research": 0,
	"soul": 0,
	"scrap": 0
}

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	_change_display()

func _on_viewport_size_changed() -> void:
	_update_size()

func _update_size() -> void:
	var viewportSize = get_viewport().size
	set_size(Vector2(viewportSize.x, 32))
	
func get_gold() -> float:
	return data["gold"]

func change_gold(pChange : float) -> void:
	data["gold"] += pChange
	
	_change_display()

func _change_display() -> void:
	infoGold.set_text(str("Gold: ", data["gold"]))
	
func get_data() -> Dictionary:
	return data

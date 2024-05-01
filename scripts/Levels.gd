extends HFlowContainer

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var LEVEL = preload("res://scene/level.tscn")

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	_init_level_slot()
	
func _on_viewport_size_changed() -> void:
	_update_size()
	
func _update_size() -> void:
	var viewportSize = get_viewport().size
	set_size(Vector2(viewportSize.x * 0.8, viewportSize.y * 0.8))
	set_position(Vector2(viewportSize.x * 0.1, viewportSize.y * 0.1))
	
func _init_level_slot() -> void:
	var levelData = globalData.get_level_data().values()
	
	for i in 10:
		var level = LEVEL.instantiate()
		if i < levelData.size():
			level.get_node("Level").set_level(levelData[i])
		add_child(level)

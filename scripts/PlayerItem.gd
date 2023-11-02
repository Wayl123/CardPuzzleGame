extends Control

var gold = 10

func _ready():
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()

func _on_viewport_size_changed():
	_update_size()

func _update_size():
	var viewportSize = get_viewport().size
	set_size(Vector2(viewportSize.x, 64))
	
func get_gold():
	return gold

func change_gold(pChange):
	gold += pChange

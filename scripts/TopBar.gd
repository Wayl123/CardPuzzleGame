extends TextureRect

@onready var menu = %Menu

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()

func _on_viewport_size_changed() -> void:
	_update_size()

func _update_size() -> void:
	var viewportSize = get_viewport().size
	set_size(Vector2(viewportSize.x, 32))
	
	menu.set_position(Vector2(viewportSize.x - 32, 0))
	


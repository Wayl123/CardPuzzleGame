extends TextureButton

@onready var map = get_tree().get_first_node_in_group("ActiveMap")

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))

func _on_button_pressed() -> void:
	map.map_complete(true)

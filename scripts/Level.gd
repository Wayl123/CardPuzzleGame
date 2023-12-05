extends TextureButton

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var data = {}

func set_level(pData : Dictionary) -> void:
	data = pData
	
	set_texture_normal(load(data["image"]))
	set_disabled(data["locked"])

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	
func _on_button_pressed() -> void:
	globalData.select_level(data)

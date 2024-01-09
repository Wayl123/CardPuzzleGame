extends TextureButton

@onready var itemDetail = get_tree().get_first_node_in_group("ItemDetail")

var data = {}

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	
func _on_button_pressed() -> void:
	if data and get_tree().has_group("ItemDetail"):
		itemDetail.set_detail(data)
		
func set_item(pData : Dictionary) -> void:
	data = pData
	
	set_texture_normal(load(data["image"]))

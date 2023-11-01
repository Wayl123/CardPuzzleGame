extends TextureButton

var itemId = ""
var data = {}

func set_item(pItemId, pData):
	itemId = pItemId
	data = pData
	
	set_texture_normal(load(data["image"]))

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))
	
func _on_button_pressed():
	if data and get_tree().has_group("ItemDetail"):
		var itemDetail = get_tree().get_first_node_in_group("ItemDetail")
		itemDetail.set_detail(itemId, data)

extends TextureButton

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var popup = get_tree().get_first_node_in_group("Popup")

@export var shop_id: String

var SHOPMENU = preload("res://scene/shop_menu.tscn")
var SELECTED = preload("res://scene/selected.tscn")

var data = {}

func set_data(pData : Dictionary) -> void:
	data = pData
	set_texture_normal(load(data["image"]))

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	
	if not data:
		data = globalData.get_shop_data_copy(shop_id)
		set_texture_normal(load(data["image"]))
	
	var contentData = {}
	for content in data["content"]:
		contentData[content] = globalData.get_unit_data_copy(content)
		
	data["content"] = contentData
		
func _on_button_pressed() -> void:
	var shopMenu = SHOPMENU.instantiate()
	
	shopMenu.set_data(data)
	shopMenu._set_global_position(get_global_position() + Vector2(2, 0) * 128)
	shopMenu.add_to_group("ActiveShopMenu")
	
	popup.add_child(shopMenu)
	_select_node()
		
func _select_node() -> void:
	if not has_node("../Selected"):
		var selected = SELECTED.instantiate()
		selected.add_to_group("ActiveSelected")
		get_parent().add_child(selected)

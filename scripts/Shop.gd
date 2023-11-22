extends TextureButton

@onready var popup = get_tree().get_first_node_in_group("Popup")

@export var shop_id: String

var SHOPMENU = preload("res://scene/shop_menu.tscn")
var SELECTED = preload("res://scene/selected.tscn")

var data = {}
var playerData = {}

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))
	
	var shop_list_path = ("res://scripts/ShopContentList.json")
	data = _load_json_file(shop_list_path)[shop_id]
	set_texture_normal(load(data["image"]))
	
	var player_list_path = ("res://scripts/UnitList.json")
	var playerData = _load_json_file(player_list_path)
	
	var contentData = {}
	for content in data["content"]:
		contentData[content] = playerData[content]
		
	data["content"] = contentData
		
func _on_button_pressed():
	var shopMenu = SHOPMENU.instantiate()
	
	shopMenu.init(data)
	shopMenu._set_global_position(get_global_position() + Vector2(2, 0) * 128)
	shopMenu.add_to_group("ActiveShopMenu")
	
	popup.add_child(shopMenu)
	_select_node()
		
func _load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist")
		
func _select_node():
	if not has_node("../Selected"):
		var selected = SELECTED.instantiate()
		selected.add_to_group("ActiveSelected")
		get_parent().add_child(selected)

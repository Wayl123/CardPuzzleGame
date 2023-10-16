extends TextureButton

@export var shop_id: String

var SHOPMENU = preload("res://scene/shop_menu.tscn")
var data = {}

func _ready():
	var shop_list_path = ("res://scripts/ShopContentList.json")
	data = _load_json_file(shop_list_path)[shop_id]
	texture_normal = load(data["image"])

func _process(delta):
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse"):
		if has_node("../ShopMenu"):
			await get_node("../ShopMenu").tree_exited
			
		var shopMenu = SHOPMENU.instantiate()
		
		shopMenu._set_position(Vector2(2, 0) * 128)
		
		get_parent().add_child(shopMenu)
		
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

extends Node2D

var unitListPath = "res://scripts/UnitList.json"
var shopListPath = "res://scripts/ShopContentList.json"
var unitData = {}
var shopData = {}

func _ready():
	DisplayServer.window_set_min_size(Vector2(512, 384))
	unitData = _load_json_file(unitListPath)
	shopData = _load_json_file(shopListPath)
	
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

func get_unit_data(pId):
	return unitData[pId].duplicate(true)
	
func get_shop_data(pId):
	return shopData[pId].duplicate(true)

extends Node

var LEVELSELECT = preload("res://scene/level_select.tscn")

var levelListPath = "res://scripts/LevelList.json"
var unitListPath = "res://scripts/UnitList.json"
var shopListPath = "res://scripts/ShopContentList.json"
var levelData = {}
var deckData = []
var unitDataTemplate = {}
var shopDataTemplate = {}

var currentLevel = {}
var currentScene

func _ready() -> void:
	_load_all_data()
	_set_current_scene(LEVELSELECT.instantiate())

func _load_json_file(filePath : String) -> Dictionary:
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist")
		
	return {}
		
func _load_all_data() -> void:
	levelData = _load_json_file(levelListPath)
	unitDataTemplate = _load_json_file(unitListPath)
	shopDataTemplate = _load_json_file(shopListPath)
	
func get_level_data() -> Dictionary:
	return levelData
		
func get_unit_data_copy(pId : String) -> Dictionary:
	return unitDataTemplate[pId].duplicate(true)
	
func get_shop_data_copy(pId : String) -> Dictionary:
	return shopDataTemplate[pId].duplicate(true)
	
func get_deck_data() -> Array:
	return deckData
	
func _set_current_scene(pNode : Node2D) -> void:
	if currentScene:
		currentScene.queue_free()
	currentScene = pNode
	add_child(pNode)
	
func select_level(pData : Dictionary) -> void:
	currentLevel = pData
	var level = load(pData["scene"]).instantiate()
	_set_current_scene(level)
		
func complete_level(pData : Dictionary, success : bool) -> void:
	var newDeck = {}
	
	newDeck = pData
	newDeck["level-image"] = currentLevel["image"]
	
	deckData.append(newDeck)
	
	if success:
		for unlock in currentLevel["completion-unlock"]:
			levelData[unlock]["locked"] = false
	
	var levelSelect = LEVELSELECT.instantiate()
	_set_current_scene(levelSelect)

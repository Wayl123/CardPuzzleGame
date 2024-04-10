extends Node

@onready var ap = %AnimationPlayer

var LEVELSELECT = preload("res://scene/level_select.tscn")

var levelListPath = "res://scripts/LevelList.json"
var unitListPath = "res://scripts/UnitList.json"
var shopListPath = "res://scripts/ShopContentList.json"
var levelData = {}
var deckData = []
var usedDeckData = []
var unitDataTemplate = {}
var shopDataTemplate = {}

var currentLevel = {}
var currentScene : Node2D
var newScene : Node2D

func _ready() -> void:
	_load_all_data()
	newScene = LEVELSELECT.instantiate()
	_set_current_scene()

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
	
func _set_current_scene() -> void:
	if currentScene:
		currentScene.queue_free()
	currentScene = newScene
	add_child(newScene)
	
func get_level_data() -> Dictionary:
	return levelData
		
func get_unit_data_copy(pId : String) -> Dictionary:
	return unitDataTemplate[pId].duplicate(true)
	
func get_shop_data_copy(pId : String) -> Dictionary:
	return shopDataTemplate[pId].duplicate(true)
	
func get_deck_data() -> Array:
	return deckData
	
func get_current_level_starting_items() -> Dictionary:
	return currentLevel["starting-items"].duplicate(true)
	
func get_used_deck_data() -> Array:
	return usedDeckData
	
func get_played() -> bool:
	return currentLevel["played"]
	
func select_level(pData : Dictionary) -> void:
	currentLevel = pData
	var level = load(pData["scene"]).instantiate()
	newScene = level
	ap.play("transition_fade")
	
func filter_deck(deckSlot : Array) -> void:
	usedDeckData = deckSlot
	deckData = deckData.filter(func(deck : Dictionary) -> bool: 
		for deckUsed in deckSlot: 
			if is_same(deck, deckUsed):
				return false
		return true
	)
		
func complete_level(pData : Dictionary, success : bool) -> void:
	var newDeck = {}
	
	newDeck = pData
	newDeck["level-image"] = currentLevel["image"]
	
	deckData.append(newDeck)
	
	currentLevel["played"] = true
	if success:
		for unlock in currentLevel["completion-unlock"]:
			levelData[unlock]["locked"] = false
	
	var levelSelect = LEVELSELECT.instantiate()
	newScene = levelSelect
	ap.play("transition_fade")

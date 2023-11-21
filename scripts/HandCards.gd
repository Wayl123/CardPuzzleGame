extends Control

@export var spreadCurve: Curve

var PLAYERCARD = preload("res://scene/player_card.tscn")

var HANDWIDTH = 2.0
var CARDSIZE = Vector2(192, 288)
var DISTBETWEENCARD = 32

var data = {}

func _ready():
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	
	var player_list_path = ("res://scripts/UnitList.json")
	data = _load_json_file(player_list_path)
	
	add_unit(data["P1-1"])
	add_unit(data["P2-1"])
	add_unit(data["P2-1"])
	
func _on_viewport_size_changed():
	_update_size()
	_update_hand()

func _update_size():
	var viewportSize = get_viewport().size
	set_size(Vector2(viewportSize.x, CARDSIZE.y - 128))
	set_position(Vector2(0, viewportSize.y - CARDSIZE.y + 128))

func _update_hand():
	var viewportSize = get_viewport().size
	var sideBorder = (viewportSize.x * 0.1) + 96
	var hRange = min(viewportSize.x - (2 * sideBorder) - CARDSIZE.x, ((CARDSIZE.x + DISTBETWEENCARD) * (get_child_count() - 1)))
	var handWidth = hRange * 0.5
	
	for card in get_children():
		var handRatio = 0.5
		
		if get_child_count() > 1:
			handRatio = float(card.get_index()) / float(get_child_count() - 1)
			
		var centerPosition = Vector2(viewportSize.x * 0.5, viewportSize.y - CARDSIZE.y + 128)
		centerPosition.x += (spreadCurve.sample(handRatio) * handWidth) - (CARDSIZE.x * 0.5)
		
		card.set_global_position(centerPosition)
		
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
		
func _can_drop_data(_pos, dataIn):
	return true
	
func _drop_data(_pos, dataIn):
	if dataIn:
		if get_tree().has_group("ActiveHoverTooltip"):
			for tooltip in get_tree().get_nodes_in_group("ActiveHoverTooltip"):
				tooltip.queue_free()
		if not get_tree().has_group("ActiveInfoBox"):
			if get_tree().has_group("RangeDisplay"):
				for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
					rangeNode.queue_free()
		
		add_unit(dataIn["origin_data"])
		dataIn["origin_node"].remove_unit(dataIn["origin_child"])

func add_unit(pData):
	var newCard = PLAYERCARD.instantiate()
	newCard.init(pData)
	newCard.set_size(CARDSIZE)
	add_child(newCard)
	_update_hand()
	
func remove_unit(pNode):
	remove_child(pNode)
	pNode.queue_free()
	_update_hand()

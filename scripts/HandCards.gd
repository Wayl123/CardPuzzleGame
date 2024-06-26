extends Control

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@export var spreadCurve: Curve

var PLAYERCARD = preload("res://scene/player_card.tscn")

var HANDWIDTH = 2.0
var CARDSIZE = Vector2(192, 288)
var DISTBETWEENCARD = 32

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	_init_hand()
	
func _on_viewport_size_changed() -> void:
	_update_size()
	_update_hand()

func _update_size() -> void:
	var viewportSize = get_viewport().size
	size = Vector2(viewportSize.x, 256)
	position = Vector2(0, viewportSize.y - 64)

func _update_hand() -> void:
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
		
		card.global_position = centerPosition
		
func _can_drop_data(_pos : Vector2, dataIn : Variant) -> bool:
	return true
	
func _drop_data(_pos : Vector2, dataIn : Variant) -> void:
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
		
func _init_hand() -> void:
	for deck in globalData.get_used_deck_data():
		for card in deck["cards"]:
			add_unit_by_id(card)

func add_unit(pData : Dictionary) -> void:
	var newCard = PLAYERCARD.instantiate()
	newCard.set_data(pData)
	newCard.size = CARDSIZE
	add_child(newCard)
	_update_hand()
	
func add_unit_by_id(pId : String) -> void:
	add_unit(globalData.get_unit_data_copy(pId))
	
func remove_unit(pNode : Node) -> void:
	remove_child(pNode)
	pNode.queue_free()
	_update_hand()

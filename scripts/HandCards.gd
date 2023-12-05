extends Control

@export var spreadCurve: Curve

var PLAYERCARD = preload("res://scene/player_card.tscn")

var HANDWIDTH = 2.0
var CARDSIZE = Vector2(192, 288)
var DISTBETWEENCARD = 32

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	
func _on_viewport_size_changed() -> void:
	_update_size()
	_update_hand()

func _update_size() -> void:
	var viewportSize = get_viewport().size
	set_position(Vector2(0, viewportSize.y - CARDSIZE.y + 128))

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
		
		card.set_global_position(centerPosition)
		
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

func add_unit(pData : Dictionary) -> void:
	var newCard = PLAYERCARD.instantiate()
	newCard.init(pData)
	newCard.set_size(CARDSIZE)
	add_child(newCard)
	_update_hand()
	
func remove_unit(pNode : Node) -> void:
	remove_child(pNode)
	pNode.queue_free()
	_update_hand()

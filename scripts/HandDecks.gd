extends Control

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

@export var spreadCurve: Curve

var PLAYERDECK = preload("res://scene/player_deck.tscn")

var HANDWIDTH = 2.0
var DECKSIZE = Vector2(192, 192)
var DISTBETWEENDECK = 32

func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	
	_update_size()
	_init_decks()
	
func _on_viewport_size_changed() -> void:
	_update_size()
	_update_hand()

func _update_size() -> void:
	var viewportSize = get_viewport().size
	set_position(Vector2(0, viewportSize.y - 64))

func _update_hand() -> void:
	var viewportSize = get_viewport().size
	var sideBorder = (viewportSize.x * 0.1) + 96
	var hRange = min(viewportSize.x - (2 * sideBorder) - DECKSIZE.x, ((DECKSIZE.x + DISTBETWEENDECK) * (get_child_count() - 1)))
	var handWidth = hRange * 0.5
	
	for deck in get_children():
		var handRatio = 0.5
		
		if get_child_count() > 1:
			handRatio = float(deck.get_index()) / float(get_child_count() - 1)
			
		var centerPosition = Vector2(viewportSize.x * 0.5, viewportSize.y - DECKSIZE.y + 128)
		centerPosition.x += (spreadCurve.sample(handRatio) * handWidth) - (DECKSIZE.x * 0.5)
		
		deck.set_global_position(centerPosition)
		
func _init_decks() -> void:
	for deck in globalData.get_deck_data():
		add_deck(deck)
		
func add_deck(pData : Dictionary) -> void:
	var newDeck = PLAYERDECK.instantiate()
	newDeck.init(pData)
	newDeck.set_size(DECKSIZE)
	add_child(newDeck)
	_update_hand()
	
func remove_deck(pNode : Node) -> void:
	remove_child(pNode)
	pNode.queue_free()
	_update_hand()

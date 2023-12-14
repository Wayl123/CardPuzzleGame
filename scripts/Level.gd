extends TextureButton

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")

var PLAYERDECK = preload("res://scene/player_deck.tscn")

var DECKSIZE = Vector2(16, 16)

var data = {}
var deckSlot = []

func set_level(pData : Dictionary) -> void:
	data = pData
	
	set_texture_normal(load(data["image"]))
	set_disabled(data["locked"])
	
	if not is_disabled():
		_init_deck_slots()

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	
func _on_button_pressed() -> void:
	globalData.select_level(data)
	
func _init_deck_slots() -> void:
	var hRange = min(get_size().x - DECKSIZE.x, (DECKSIZE.x * (data["deck-slot"] - 1)))
	
	for slot in data["deck-slot"]:
		var deckRatio = 0
		
		if data["deck-slot"] > 1:
			deckRatio = float(slot) / float(data["deck-slot"] - 1)
		
		var newDeck = PLAYERDECK.instantiate()
		newDeck.set_size(DECKSIZE)
		newDeck.set_position(Vector2(deckRatio * hRange, get_size().y))
		newDeck.set("deckType", 2)
		add_child(newDeck)
	
func _can_drop_data(_pos : Vector2, dataIn : Variant) -> bool:
	if data and not is_disabled() and data["deck-slot"] - deckSlot.size() > 0:
		return true
	return false
	
func _drop_data(_pos : Vector2, dataIn : Variant) -> void:
	if dataIn:
		dataIn["origin_node"].remove_deck(dataIn["origin_child"])
		
		deckSlot.append(dataIn["origin_data"])

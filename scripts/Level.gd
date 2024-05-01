extends TextureButton

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var playerHandDeck = get_tree().get_first_node_in_group("PlayerHandDeck")

var LEVELDECK = preload("res://scene/level_deck.tscn")
var CONFIRMATIONBOX = preload("res://scene/confirmation_box.tscn")

var DECKSIZE = Vector2(16, 16)

var data = {}
var deckSlot = []

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	
func _on_button_pressed() -> void:
	var confirmationBox = CONFIRMATIONBOX.instantiate()
	confirmationBox.set_title("Confirm Level Select")
	var dialogText = str("Confirm entering level ", data["name"])
	if deckSlot.size() > 0:
		dialogText += str(" with ", deckSlot.size())
		dialogText += " deck" if deckSlot.size() == 1 else " decks"
	dialogText += "?"
	confirmationBox.set_text(dialogText)
	add_child(confirmationBox)
	confirmationBox.popup_centered()
	confirmationBox.set_visible(true)
	confirmationBox.connect("confirmed", Callable(self, "_on_confirm"))
	
func _on_confirm() -> void:
	globalData.filter_deck(deckSlot)
	globalData.select_level(data)
	
func _init_deck_slots() -> void:
	var hRange = min(get_size().x - DECKSIZE.x, (DECKSIZE.x * (data["deck-slot"] - 1)))
	
	for slot in data["deck-slot"]:
		var deckRatio = 0
		
		if data["deck-slot"] > 1:
			deckRatio = float(slot) / float(data["deck-slot"] - 1)
		
		var newDeck = LEVELDECK.instantiate()
		newDeck.set_size(DECKSIZE)
		newDeck.set_position(Vector2(deckRatio * hRange, get_size().y))
		add_child(newDeck)
	
func _can_drop_data(_pos : Vector2, dataIn : Variant) -> bool:
	if data and not is_disabled() and data["deck-slot"] - deckSlot.size() > 0:
		return true
	return false
	
func _drop_data(_pos : Vector2, dataIn : Variant) -> void:
	if dataIn and not dataIn["origin_node"] == self:
		dataIn["origin_node"].remove_deck(dataIn["origin_child"])
		
		if data["deck-slot"] - deckSlot.size() > 0:
			deckSlot.append(dataIn["origin_data"])
			
			_update_deck_data()
		
func _update_deck_data() -> void:
	for deckIndex in deckSlot.size():
		get_child(deckIndex).update_data(deckSlot[deckIndex])
		
func set_level(pData : Dictionary) -> void:
	data = pData
	
	set_texture_normal(load(data["image"]))
	set_disabled(data["locked"])
	
	if not is_disabled():
		_init_deck_slots()
		
func remove_deck(pNode : Node) -> void:
	if pNode.get_index() + 1 <= deckSlot.size():
		deckSlot.remove_at(pNode.get_index())
	pNode.update_data({})
	
	_update_deck_data()
	
func return_deck(pNode : Node, pData : Dictionary) -> void:
	playerHandDeck.add_deck(pData)
	
	remove_deck(pNode)

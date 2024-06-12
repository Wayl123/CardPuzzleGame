extends TextureButton

@onready var deckCover = %DeckCover
@onready var deckLevel = %DeckLevel

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")

var data = {}

func _ready() -> void:
	_data_init()
	
func _get_drag_data(_pos : Vector2) -> Variant:
	var dataOut = {}
	
	if data:
		dataOut["origin_node"] = get_parent()
		dataOut["origin_child"] = self
		dataOut["origin_data"] = data
	
		var dragPreview = DRAGPREVIEW.instantiate()
		dragPreview.texture = texture_normal
		dragPreview.modulate = deckCover.modulate
		add_child(dragPreview)
	
	return dataOut
	
func _data_init() -> void:
	deckCover.set_transform_scale(size.x / 128)
	deckCover.position = deckCover.position + (size * 0.5)
	
	_set_deck_cover()
	
func _set_deck_cover() -> void:
	if data:
		modulate = Color(1, 1, 1, 1)
		if data["clear"]:
			deckCover.modulate = Color(0, 1, 0, 0.25)
		else:
			deckCover.modulate = Color(1, 0, 0, 0.25)
		deckLevel.texture = load(data["level-image"])
	else:
		modulate = Color(0, 0, 0, 1)
	
func set_data(pData : Dictionary) -> void:
	data = pData
	
func update_data(pData : Dictionary) -> void:
	data = pData
	
	_set_deck_cover()

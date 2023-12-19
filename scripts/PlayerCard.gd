extends NinePatchRect

@onready var infoName = %Name
@onready var infoImage = %CardImage
@onready var infoHealth = %Health
@onready var infoAttack = %Attack
@onready var infoEffect = %EffectSimplified

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var PLAYER = preload("res://scene/player.tscn")

var data = {}

func set_data(pData : Dictionary) -> void:
	data = pData

func _ready() -> void:
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	_data_init()
	add_to_group("PlayerCards")

func _on_mouse_entered() -> void:
	var cardPosition = get_global_position()
	if cardPosition.y >= get_viewport().size.y - get_size().y + 128:
		cardPosition.y -= 128
	set_global_position(cardPosition)
	
func _on_mouse_exited() -> void:
	var cardPosition = get_global_position()
	if cardPosition.y < get_viewport().size.y - get_size().y + 128:
		cardPosition.y += 128
	set_global_position(cardPosition)

func _get_drag_data(_pos : Vector2) -> Variant:
	var dataOut = {}
	
	dataOut["origin_node"] = get_parent()
	dataOut["origin_child"] = self
	dataOut["origin_data"] = data
	
	var dragPreview = DRAGPREVIEW.instantiate()
	dragPreview.set_texture(load(data["image"]))
	add_child(dragPreview)
	
	return dataOut

func _data_init() -> void:
	infoName.set_text(data["name"])
	infoImage.set_texture(load(data["image"]))
	infoHealth.set_text(str("Health: ", data["health"], "/", data["max-health"]))
	infoAttack.set_text(str("Attack: ", data["attack"]))
	infoEffect.set_text("Effect Placeholder")
	
func get_deck(success : bool) -> Array:
	var deckCards = []
	
	if success:
		if data.has("on-completion"):
			var onCompletion = data["on-completion"]
			
			if onCompletion.has("deck"):
				deckCards += onCompletion["deck"]
				
	return deckCards

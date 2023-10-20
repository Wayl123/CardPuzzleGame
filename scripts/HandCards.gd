extends Node2D

var PLAYERCARD = preload("res://scene/player_card.tscn")

@export var spreadCurve: Curve

var HANDWIDTH = 2.0
var CARDSIZE = Vector2(192, 288)
var DISTBETWEENCARD = 32

var handList = []

func _ready():
	get_tree().root.connect("size_changed", Callable(self, "_on_viewport_size_changed"))
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	

func _process(delta):
	pass
	
func _on_viewport_size_changed():
	_update_hand()

func _update_hand():
	var viewportSize = get_viewport().size
	var sideBorder = viewportSize.x * 0.1
	var hRange = min(viewportSize.x - (2 * sideBorder) - CARDSIZE.x, ((CARDSIZE.x + DISTBETWEENCARD) * (get_child_count() -1)))
	var handWidth = hRange * 0.5
	
	for card in get_children():
		var handRatio = 0.5
		
		if get_child_count() > 1:
			handRatio = float(card.get_index()) / float(get_child_count() - 1)
			
		var centerPosition = Vector2(viewportSize.x * 0.5, viewportSize.y - CARDSIZE.y + 128)
		centerPosition.x += (spreadCurve.sample(handRatio) * handWidth) - (CARDSIZE.x * 0.5)
		
		card.set_position(centerPosition)
			
func draw_card():
	var newCard = PLAYERCARD.instantiate()
	handList.append(1)
	newCard.set_size(CARDSIZE)
	add_child(newCard)
	_update_hand()

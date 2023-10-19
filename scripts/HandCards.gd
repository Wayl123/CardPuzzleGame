extends Node2D

var PLAYERCARD = preload("res://scene/player_card.tscn")

@export var spreadCurve: Curve

var HANDWIDTH = 2.0
var CARDSIZE = Vector2(192, 288)
var SIDEBORDER = 128
var DISTBETWEENCARD = 32

var handList = []

func _ready():
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	draw_card()
	_update_hand()

func _process(delta):
	pass

func _update_hand():
	var viewportSize = get_viewport().size
	var hRange = min(viewportSize.x - (2 * SIDEBORDER) - CARDSIZE.x, ((CARDSIZE.x + DISTBETWEENCARD) * (get_child_count() -1)))
	var handWidth = hRange * 0.5
	
	for card in get_children():
		var handRatio = 0.5
		
		if get_child_count() > 1:
			handRatio = float(card.get_index()) / float(get_child_count() - 1)
			
		var centerPosition = Vector2(viewportSize.x * 0.5, viewportSize.y * 0.8)
		centerPosition.x += (spreadCurve.sample(handRatio) * handWidth) - (CARDSIZE.x * 0.5)
		
		card.set_position(centerPosition)
			
func draw_card():
	var newCard = PLAYERCARD.instantiate()
	handList.append(1)
	newCard.set_size(CARDSIZE)
	add_child(newCard)

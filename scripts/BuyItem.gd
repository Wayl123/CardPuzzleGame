extends Button

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))
	
func _on_button_pressed():
	var data
	var itemDetail = get_tree().get_first_node_in_group("ItemDetail")
	data = itemDetail.get_data()
	
	if data and get_tree().has_group("PlayerItem") and get_tree().has_group("PlayerCards"):
		var playerItem = get_tree().get_first_node_in_group("PlayerItem")
		var playerCards = get_tree().get_first_node_in_group("PlayerCards")
		var gold = playerItem.get_gold()
		var cost = data["cost"]
		
		if gold >= cost:
			playerCards.add_unit(data)
			playerItem.change_gold(-cost)
		else:
			print("Not enough gold") #to be replaced with notification text in gam
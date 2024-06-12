extends Button

@onready var itemDetail = get_tree().get_first_node_in_group("ItemDetail")
@onready var playerItem = get_tree().get_first_node_in_group("PlayerItem")
@onready var playerHand = get_tree().get_first_node_in_group("PlayerHand")

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	
func _on_button_pressed() -> void:
	var data
	data = itemDetail.get_data()
	
	if data:
		var gold = playerItem.get_gold()
		var cost = data["cost"]
		
		if gold >= cost:
			playerHand.add_unit(data)
			playerItem.change_gold(-cost)
		else:
			var dialog = AcceptDialog.new()
			dialog.title = "Alert"
			dialog.dialog_text = "Out of gold"
			add_child(dialog)
			dialog.popup_centered()

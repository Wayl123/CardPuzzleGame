extends MenuButton

var CONFIRMATIONBOX = preload("res://scene/confirmation_box.tscn")

@onready var map = get_tree().get_first_node_in_group("ActiveMap")

func _ready() -> void:
	get_popup().connect("index_pressed", Callable(self, "_on_menu_select"))

func _on_menu_select(index : int):
	var itemName = get_popup().get_item_text(index)
	match itemName:
		"Forfeit":
			var confirmationBox = CONFIRMATIONBOX.instantiate()
			confirmationBox.set_title("Confirm Forfeit Level")
			confirmationBox.set_text("Are you sure you want to forfeit this level?")
			add_child(confirmationBox)
			confirmationBox.popup_centered()
			confirmationBox.set_visible(true)
			confirmationBox.connect("confirmed", Callable(self, "_on_confirm"))
			
func _on_confirm() -> void:
	map.map_complete(false)

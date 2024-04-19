extends MenuButton

var CONFIRMATIONBOX = preload("res://scene/confirmation_box.tscn")
var GAMEINFO = preload("res://scene/game_info.tscn")

func _ready() -> void:
	get_popup().connect("index_pressed", Callable(self, "_on_menu_select"))

func _on_menu_select(index : int) -> void:
	var itemName = get_popup().get_item_text(index)
	match itemName:
		"Info":
			var gameInfo = GAMEINFO.instantiate()
			add_child(gameInfo)
			gameInfo.set_global_position(Vector2.ZERO)

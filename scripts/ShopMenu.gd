extends NinePatchRect

@onready var rowContainer = %RowContainer

var SHOPITEM = preload("res://scene/shop_item.tscn")

var drag_position = null
var data = {}

func _ready() -> void:
	_init_item_slots()
	_add_shop_item()

func _process(delta : float) -> void:
	if (not Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse") 
	and not (get_tree().has_group("Tutorial") 
	and (not get_tree().get_first_node_in_group("Tutorial").get_dialog_type() == "action" 
	or get_tree().get_first_node_in_group("Tutorial").get_progress() == 5 
	or get_tree().get_first_node_in_group("Tutorial").get_progress() == 9))):
		if get_tree().has_group("ActiveSelected"):
			get_tree().get_first_node_in_group("ActiveSelected").queue_free()
		queue_free()

	if Input.is_action_pressed("LeftMouse"):
		drag_position = get_global_mouse_position() - global_position
	else:
		drag_position = null
		
func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion and drag_position != null:
		set_global_position(get_global_mouse_position() - drag_position)
		
func _init_item_slots() -> void:
	for m in 18:
		var shopItem = SHOPITEM.instantiate()
		shopItem.add_to_group("ItemSlots")
		rowContainer.add_child(shopItem)
		
func _add_shop_item() -> void:
	var itemSlots = get_tree().get_nodes_in_group("ItemSlots")
	var itemPointer = 0
	
	for key in data["content"].keys():
		itemSlots[itemPointer].get_node("Item").set_item(data["content"][key])
		itemPointer += 1

func set_data(pData : Dictionary) -> void:
	data = pData

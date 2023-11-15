extends NinePatchRect

@onready var rowContainer = %RowContainer

var SHOPITEM = preload("res://scene/shop_item.tscn")

var drag_position = null
var data = {}
var itemPointer = 0

func init(pData):
	data = pData

func _ready():
	_init_item_slots()
	_add_shop_item()

func _process(delta):
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse"):
		if get_tree().has_group("ActiveSelected"):
			get_tree().get_first_node_in_group("ActiveSelected").queue_free()
		queue_free()

	if Input.is_action_pressed("LeftMouse"):
		drag_position = get_global_mouse_position() - global_position
	else:
		drag_position = null
		
func _input(event):
	if event is InputEventMouseMotion and drag_position != null:
		set_global_position(get_global_mouse_position() - drag_position)
		
func _init_item_slots():
	for n in 3:
		var itemRow = HBoxContainer.new()
		itemRow.set_alignment(1)
		itemRow.set("theme_override_constants/separation", 32)
		
		for m in 6:
			var shopItem = SHOPITEM.instantiate()
			shopItem.add_to_group("ItemSlots")
			itemRow.add_child(shopItem)
		
		rowContainer.add_child(itemRow)
		
func _add_shop_item():
	var itemSlots = get_tree().get_nodes_in_group("ItemSlots")
	
	for key in data["content"].keys():
		itemSlots[itemPointer].get_node("Item").set_item(key, data["content"][key])
		itemPointer += 1

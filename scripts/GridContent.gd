extends TextureButton

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var ENEMY = preload("res://scene/enemy.tscn")
var PLAYER = preload("res://scene/player.tscn")
var SHOP = preload("res://scene/shop.tscn")
var PORTAL = preload("res://scene/portal.tscn")
	
func _can_drop_data(_pos : Vector2, dataIn : Variant) -> bool:
	if not is_disabled():
		return true
	return false
	
func _drop_data(_pos : Vector2, dataIn : Variant) -> void:
	if dataIn:
		if get_tree().has_group("ActiveHoverTooltip"):
			for tooltip in get_tree().get_nodes_in_group("ActiveHoverTooltip"):
				tooltip.queue_free()
		if not get_tree().has_group("ActiveInfoBox"):
			if get_tree().has_group("RangeDisplay"):
				for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
					rangeNode.queue_free()
		
		dataIn["origin_node"].remove_unit(dataIn["origin_child"])
		
		for child in get_children():
			if child.is_in_group("PlayerUnits"):
				remove_unit(child)
				dataIn["origin_node"].add_unit(child.get_data(), "P")
				
		add_unit(dataIn["origin_data"], "P")
		
func add_unit(pData : Dictionary, type : String) -> void:
	var unit
	match type:
		"E": unit = ENEMY.instantiate()
		"P": unit = PLAYER.instantiate()
		"S": unit = SHOP.instantiate()
		"X": unit = PORTAL.instantiate()
		
	if pData:
		unit.set_data(pData)
	add_child(unit)
	
func add_unit_by_id(pId : String) -> void:
	var unit
	var type = pId[0]
	match type:
		"E": unit = ENEMY.instantiate()
		"P": unit = PLAYER.instantiate()
		"S": unit = SHOP.instantiate()
		"X": unit = PORTAL.instantiate()
			
	if type != "X":
		unit.set("unit_id", pId)
	add_child(unit)
	
func remove_unit(pNode : Node) -> void:
	remove_child(pNode)
	pNode.queue_free()

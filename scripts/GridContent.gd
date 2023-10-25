extends TextureButton

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var PLAYER = preload("res://scene/player.tscn")
	
func _can_drop_data(_pos, dataIn):
	if !disabled:
		return true
	return false
	
func _drop_data(_pos, dataIn):
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
				dataIn["origin_node"].add_unit(child.get_data())
				
		add_unit(dataIn["origin_data"])
		
func add_unit(pData):
	var player = PLAYER.instantiate()
	player.init(pData)
	add_child(player)
	
func remove_unit(pNode):
	remove_child(pNode)
	pNode.queue_free()

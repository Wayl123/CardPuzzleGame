extends TextureButton

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")

func _ready():
	pass

func _get_drag_data(_pos):
	var data = {}
	
	if !disabled and has_node("Player"):
		data["origin_node"] = self
		data["origin_child"] = get_node("Player")
		
		var dragPreview = DRAGPREVIEW.instantiate()
		dragPreview.set_texture(get_node("Player").texture_normal)
		add_child(dragPreview)
	
	return data
	
func _can_drop_data(_pos, data):
	if !disabled:
		return true
	return false
	
func _drop_data(_pos, data):
	if data:
		data["origin_node"].remove_child(data["origin_child"])
		
		if has_node("Player"):
			var playerNode = get_node("Player")
			remove_child(playerNode)
			data["origin_node"].add_child(playerNode)
			
		add_child(data["origin_child"])
		
		if get_tree().has_group("ActiveHoverTooltip"):
			for tooltip in get_tree().get_nodes_in_group("ActiveHoverTooltip"):
				tooltip.queue_free()
		if not get_tree().has_group("ActiveInfoBox"):
			if get_tree().has_group("RangeDisplay"):
				for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
					rangeNode.queue_free()
		
		

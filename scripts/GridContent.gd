extends TextureButton

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var PLAYER = preload("res://scene/player.tscn")

func _ready():
	pass

func _get_drag_data(_pos):
	var dataOut = {}
	
	if !disabled and has_node("Player"):
		dataOut["origin_node"] = self
		dataOut["origin_child"] = get_node("Player")
		dataOut["origin_data"] = get_node("Player").get_data()
		
		var dragPreview = DRAGPREVIEW.instantiate()
		dragPreview.set_texture(get_node("Player").texture_normal)
		add_child(dragPreview)
	
	return dataOut
	
func _can_drop_data(_pos, data):
	if !disabled:
		return true
	return false
	
func _drop_data(_pos, data):
	if data:
		data["origin_node"].remove_unit(data["origin_child"])
		
		if has_node("Player"):
			var playerNode = get_node("Player")
			data["origin_node"].add_unit(playerNode.get_data())
			remove_unit(playerNode)
			
		add_unit(data["origin_data"])
		
		if get_tree().has_group("ActiveHoverTooltip"):
			for tooltip in get_tree().get_nodes_in_group("ActiveHoverTooltip"):
				tooltip.queue_free()
		if not get_tree().has_group("ActiveInfoBox"):
			if get_tree().has_group("RangeDisplay"):
				for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
					rangeNode.queue_free()
		
func add_unit(pData):
	var player = PLAYER.instantiate()
	player.init(pData)
	add_child(player)
	
func remove_unit(pNode):
	pNode.queue_free()

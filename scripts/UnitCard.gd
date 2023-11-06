extends TextureButton

var HOVERTOOLTIP = preload("res://scene/hover_tooltip.tscn")
var INFOBOX = preload("res://scene/info_box.tscn")
var RANGE = preload("res://scene/attack_range.tscn")
var SELECTED = preload("res://scene/selected.tscn")
var data = {}

func _ready():
	connect("pressed", Callable(self, "_on_button_pressed"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
		
func _on_button_pressed():
	var infoBox = INFOBOX.instantiate()
	
	infoBox.init(data)
	infoBox._set_global_position(get_global_position() + Vector2(2, 0) * 128)
	infoBox.add_to_group("ActiveInfoBox")
	
	var popup = get_tree().get_first_node_in_group("Popup")
	
	popup.add_child(infoBox)
	_select_node()
	_range_display()
	
	if get_tree().has_group("ActiveHoverTooltip"):
		for tooltip in get_tree().get_nodes_in_group("ActiveHoverTooltip"):
			tooltip.queue_free()
	
func _on_mouse_entered():
	if not get_tree().has_group("ActiveInfoBox") and not has_node("HoverTooltip"):
		var hoverTooltip = HOVERTOOLTIP.instantiate()
		
		hoverTooltip.set_visible(false)
		hoverTooltip.init(data)
		hoverTooltip.add_to_group("ActiveHoverTooltip")
		
		add_child(hoverTooltip)
	
	await get_tree().create_timer(0.2).timeout
	
	if has_node("HoverTooltip") and not get_node("HoverTooltip").is_visible():
		get_node("HoverTooltip").set_visible(true)
		
		_range_display()

func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		if get_tree().has_group("ActiveHoverTooltip"):
			for tooltip in get_tree().get_nodes_in_group("ActiveHoverTooltip"):
				tooltip.queue_free()
		if not get_tree().has_group("ActiveInfoBox"):
			if get_tree().has_group("RangeDisplay"):
				for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
					rangeNode.queue_free()

func _load_json_file(filePath : String):
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist")
		
func _range_display():
	if not get_tree().has_group("RangeDisplay"):
		for aRange in data["range"]:
			var targetPos = Vector2(aRange[0], aRange[1]) * 128
			var targetGlobalPos = global_position + targetPos
			for targetNode in get_tree().get_nodes_in_group("TargetableNode"):
				if targetNode.get_global_position() == targetGlobalPos:
					var attackRange = RANGE.instantiate()
					attackRange.set_position(targetPos)
					attackRange.add_to_group("RangeDisplay")
					get_parent().add_child(attackRange)

func _select_node():
	if not has_node("../Selected"):
		var selected = SELECTED.instantiate()
		selected.add_to_group("ActiveSelected")
		get_parent().add_child(selected)

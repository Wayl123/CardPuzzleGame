extends TextureButton

@export var enemy_id: String

var HOVERTOOLTIP = preload("res://scene/hover_tooltip.tscn")
var INFOBOX = preload("res://scene/info_box.tscn")
var RANGE = preload("res://scene/attack_range.tscn")
var SELECTED = preload("res://scene/selected.tscn")
var data = {}

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	var enemy_list_path = ("res://scripts/EnemyList.json")
	data = _load_json_file(enemy_list_path)[enemy_id]
	texture_normal = load(data["image"])

func _process(delta):
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse"):
		if has_node("../InfoBox"):
			await get_node("../InfoBox").tree_exited
			
		var infoBox = INFOBOX.instantiate()
		
		infoBox._set_position(Vector2(2, 0) * 128)
		infoBox.init(data)
		
		get_parent().add_child(infoBox)
		_select_node()
		_range_display()

func _on_mouse_entered():
	if not has_node("HoverTooltip"):
		var hoverTooltip = HOVERTOOLTIP.instantiate()
		
		hoverTooltip.set_visible(false)
		
		add_child(hoverTooltip)
	
	await get_tree().create_timer(0.2).timeout
	
	if has_node("HoverTooltip") and not get_node("HoverTooltip").is_visible():
		_populate_hover_tooltip()
		get_node("HoverTooltip").set_visible(true)
		
		_range_display()

func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		if has_node("HoverTooltip"):
			get_node("HoverTooltip").queue_free()
		if not has_node("../InfoBox"):
			if has_node("../Range"):
				get_node("../Range").queue_free()
		
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
	if not has_node("../Range"):
		for aRange in data["range"]:
			var targetPos = Vector2(aRange[0], aRange[1]) * 128
			var targetGlobalPos = global_position + targetPos
			for targetNode in get_tree().get_nodes_in_group("TargetableNode"):
				if targetNode.get_global_position() == targetGlobalPos:
					var attackRange = RANGE.instantiate()
					attackRange.set_position(targetPos)
					get_parent().add_child(attackRange)

func _select_node():
	if not has_node("../Selected"):
		var selected = SELECTED.instantiate()
		get_parent().add_child(selected)

func _populate_hover_tooltip():
	if has_node("HoverTooltip"):
		get_node("HoverTooltip/TooltipItems/Name").set_text(data["name"])
		get_node("HoverTooltip/TooltipItems/Health").set_text(str("Health: ", data["health"], "/", data["max-health"]))
		get_node("HoverTooltip/TooltipItems/Attack").set_text(str("Attack: ", data["attack"]))
	


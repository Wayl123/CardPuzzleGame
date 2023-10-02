extends TextureButton

@export var enemy_id: String

var HOVERTOOLTIP = preload("res://scene/hover_tooltip.tscn")
var RANGE = preload("res://scene/attack_range.tscn")
var data = {}

func _ready():
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	connect("mouse_exited", Callable(self, "_on_mouse_exited"))
	
	var enemy_list_path = ("res://scripts/EnemyList.json")
	data = _load_json_file(enemy_list_path)[enemy_id]
	texture_normal = load(data["image"])

func _process(delta):
	pass

func _on_mouse_entered():
	var hoverTooltip = HOVERTOOLTIP.instantiate()
	
	hoverTooltip.set_visible(false)
	
	add_child(hoverTooltip)
	
	await get_tree().create_timer(0.2).timeout
	if has_node("HoverTooltip"):
		get_node("HoverTooltip/TooltipItems/Name").set_text(data["name"])
		get_node("HoverTooltip/TooltipItems/Health").set_text(str("Health: ", data["health"], "/", data["max-health"]))
		get_node("HoverTooltip/TooltipItems/Attack").set_text(str("Attack: ", data["attack"]))
		get_node("HoverTooltip").set_visible(true)
		
		for range in data["range"]:
			var targetPos = Vector2(range[0], range[1]) * 128
			var targetGlobalPos = global_position + targetPos
			for targetNode in get_tree().get_nodes_in_group("TargetableNode"):
				if targetNode.get_global_position() == targetGlobalPos:
					var attackRange = RANGE.instantiate()
					attackRange.set_position(targetPos)
					get_node("HoverTooltip").add_child(attackRange)

func _on_mouse_exited():
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()):
		get_node("HoverTooltip").queue_free()
		
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

extends "res://scripts/UnitCard.gd"

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")
var LOCKED = preload("res://scene/locked.tscn")

func _ready() -> void:
	super()
	
	add_to_group("PlayerUnits")
	
func _process(delta : float) -> void:
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and not get_parent().disabled:
		if Input.is_action_just_pressed("RotateRight") or Input.is_action_just_pressed("RotateLeft"):
			if Input.is_action_just_pressed("RotateRight"):
				data["rotation"] = fmod(rotation_degrees + 90, 360)
				rotation_degrees = data["rotation"]
				for rangeIndex in data["range"].size():
					var aRange = data["range"][rangeIndex]
					data["range"][rangeIndex] = [-aRange[1], aRange[0]]
			else:
				data["rotation"] = fmod(rotation_degrees - 90, 360)
				rotation_degrees = data["rotation"]
				for rangeIndex in data["range"].size():
					var aRange = data["range"][rangeIndex]
					data["range"][rangeIndex] = [aRange[1], -aRange[0]]
			if get_tree().has_group("RangeDisplay"):
				for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
					rangeNode.queue_free()
			await get_tree().create_timer(0.1).timeout
			_range_display()
		
func _get_drag_data(_pos : Vector2) -> Variant:
	var dataOut = {}
	
	if not get_parent().disabled:
		dataOut["origin_node"] = get_parent()
		dataOut["origin_child"] = self
		dataOut["origin_data"] = data
			
		var dragPreview = DRAGPREVIEW.instantiate()
		dragPreview.texture = load(data["image"])
		add_child(dragPreview)
	
	return dataOut

func lock_player() -> void:
	if not has_node("../Locked"):
		get_parent().disabled = true
		var locked = LOCKED.instantiate()
		get_parent().add_child(locked)
		
func get_deck(success : bool) -> Array:
	var deckCards = []
	
	if success:
		if data.has("on-completion"):
			var onCompletion = data["on-completion"]
			
			if onCompletion.has("deck"):
				deckCards += onCompletion["deck"]
	else:
		if data.has("on-fail"):
			var onFail = data["on-fail"]
			
			if onFail.has("deck"):
				deckCards += onFail["deck"]

	return deckCards

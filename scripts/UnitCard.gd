extends TextureButton

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var map = get_tree().get_first_node_in_group("ActiveMap")
@onready var popup = get_tree().get_first_node_in_group("Popup")
@onready var playerItem = get_tree().get_first_node_in_group("PlayerItem")
@onready var playerHand = get_tree().get_first_node_in_group("PlayerHand")

@export var unit_id : String:
	set (value):
		unit_id = value

var HOVERTOOLTIP = preload("res://scene/hover_tooltip.tscn")
var INFOBOX = preload("res://scene/info_box.tscn")
var RANGE = preload("res://scene/attack_range.tscn")
var SELECTED = preload("res://scene/selected.tscn")
var DAMAGENUMBER = preload("res://scene/damage_number.tscn")
var UNITDEATH = preload("res://scene/unit_death.tscn")

var unit_list_path = "res://scripts/UnitList.json"
var data = {}

func _ready() -> void:
	connect("pressed", Callable(self, "_on_button_pressed"))
	connect("mouse_entered", Callable(self, "_on_mouse_entered"))
	
	set_pivot_offset(get_size() / 2)
	
	if not data:
		data = globalData.get_unit_data_copy(unit_id)
		set_texture_normal(load(data["image"]))
		
func _on_button_pressed() -> void:
	await get_tree().create_timer(0.1).timeout
	var infoBox = INFOBOX.instantiate()
	
	infoBox.set_data(data)
	infoBox.set_global_position(get_global_position() + Vector2(2, 0) * 128)
	infoBox.add_to_group("ActiveInfoBox")
	
	popup.add_child(infoBox)
	
	_select_node()
	_range_display()
	
	if get_tree().has_group("ActiveHoverTooltip"):
		for node in get_tree().get_nodes_in_group("ActiveHoverTooltip"):
			node.queue_free()
	
func _on_mouse_entered() -> void:
	if not get_tree().has_group("ActiveInfoBox"):
		var hoverTooltip = HOVERTOOLTIP.instantiate()
		
		hoverTooltip.set_visible(false)
		hoverTooltip.set_data(data)
		hoverTooltip.add_to_group("ActiveHoverTooltip")
		
		get_parent().add_child(hoverTooltip)
		
		await get_tree().create_timer(0.2).timeout
		
		if is_instance_valid(hoverTooltip):
			hoverTooltip.set_visible(true)
			
			_range_display()
					
func _range_display() -> void:
	if not get_tree().has_group("RangeDisplay"):
		for aRange in data["range"]:
			var targetPos = Vector2(aRange[0], aRange[1]) * 128
			var targetGlobalPos = get_global_position() + targetPos
			for targetNode in get_tree().get_nodes_in_group("TargetableNode"):
				if targetNode.get_global_position() == targetGlobalPos:
					var attackRange = RANGE.instantiate()
					attackRange.set_position(targetPos + Vector2(64, 64))
					attackRange.add_to_group("RangeDisplay")
					get_parent().add_child(attackRange)

func _select_node() -> void:
	if not get_tree().has_group("ActiveSelected"):
		var selected = SELECTED.instantiate()
		selected.add_to_group("ActiveSelected")
		get_parent().add_child(selected)
					
func set_data(pData : Dictionary) -> void:
	data = pData
	texture_normal = load(data["image"])
	
func get_data() -> Dictionary:
	return data
		
func take_damage(pDmg : float) -> void:
	if data["health"] > 0:
		var damageNumber = DAMAGENUMBER.instantiate()
		var spawnPosition = get_global_position()
		spawnPosition.x += 64
		spawnPosition.y += 64
		popup.add_child(damageNumber)
		damageNumber.set_values_and_animate(pDmg, spawnPosition)
	
		data["health"] -= pDmg
		if data["health"] <= 0:
			var unitDeath = UNITDEATH.instantiate()
			unitDeath.set_global_position(spawnPosition)
			popup.add_child(unitDeath)
			if is_in_group("CurrentEnemy") and get_tree().has_group("ActiveMap"):
				remove_from_group("CurrentEnemy")
				map.check_enemy_cleared()
				get_parent().set_disabled(false)
				for player in get_tree().get_nodes_in_group("PlayerUnits"):
					player.on_effect("all-kill")
			if is_in_group("PlayerUnits"):
				for enemy in get_tree().get_nodes_in_group("CurrentEnemy"):
					enemy.on_effect("all-kill")
			on_effect("death")
			queue_free()
		
func on_effect(pEffect : String) -> void:
	if data.has(str("on-", pEffect)):
		var onEffect = data[str("on-", pEffect)]
				
		if onEffect.has("coin"):
			playerItem.change_gold(onEffect["coin"])
			
		if onEffect.has("becomes"):
			get_parent().add_unit_by_id(onEffect["becomes"])
			queue_free()
			
		if onEffect.has("gives"):
			for give in onEffect["gives"]:
				playerHand.add_unit_by_id(give)

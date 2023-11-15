extends NinePatchRect

@onready var infoName = %Name
@onready var infoDescription = %Description
@onready var infoImage = %Image
@onready var infoHealth = %Health
@onready var infoAttack = %Attack
@onready var infoDeathEffect = %DeathEffect
@onready var infoVictoryEffect = %VictoryEffect

var drag_position = null
var data = {}

func init(pData):
	data = pData

func _ready():
	_populate_data()

func _process(delta):
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse"):
		if get_tree().has_group("RangeDisplay"):
			for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
				rangeNode.queue_free()
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

func _populate_data():
	infoName.set_text(data["name"])
	infoDescription.set_text("Description placeholder")
	infoImage.set_texture(load(data["image"]))
	infoHealth.set_text(str("Health: ", data["health"], "/", data["max-health"]))
	infoAttack.set_text(str("Attack: ", data["attack"]))
	infoDeathEffect.set_text("Death effect placeholder")
	infoVictoryEffect.set_text("")

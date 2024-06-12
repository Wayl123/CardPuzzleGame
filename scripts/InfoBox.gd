extends Panel

@onready var infoName = %Name
@onready var infoDescription = %Description
@onready var infoImage = %Image
@onready var infoDetail = %Detail

var drag_position = null
var data = {}

func _ready() -> void:
	_populate_data()

func _process(delta : float) -> void:
	if not Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_just_pressed("LeftMouse"):
		if get_tree().has_group("RangeDisplay"):
			for rangeNode in get_tree().get_nodes_in_group("RangeDisplay"):
				rangeNode.queue_free()
		if get_tree().has_group("ActiveSelected"):
			get_tree().get_first_node_in_group("ActiveSelected").queue_free()
		queue_free()
	
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_pressed("LeftMouse"):
		drag_position = get_global_mouse_position() - global_position
	else:
		drag_position = null

func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion and drag_position != null:
		global_position = get_global_mouse_position() - drag_position

func _populate_data() -> void:
	infoName.text = str("[b]", data["name"], "[/b]")
	infoDescription.text = data["desc"]
	infoImage.texture = load(data["image"])
	infoDetail.text += str("[b]Health:[/b] ", data["health"], "/", data["max-health"], "\n")
	infoDetail.text += str("[b]Attack:[/b] ", data["attack"], "\n")
	
	if data.has("on-death-desc"):
		infoDetail.text += str("[b]On Death:[/b] ", data["on-death-desc"], "\n")
	if data.has("on-victory-desc"):
		infoDetail.text += str("[b]On Victory:[/b] ", data["on-victory-desc"], "\n")
	if data.has("on-all-kill-desc"):
		infoDetail.text += str("[b]On All Kill:[/b] ", data["on-all-kill-desc"], "\n")
	if data.has("on-completion-desc"):
		infoDetail.text += str("[b]On Completion:[/b] ", data["on-completion-desc"], "\n")
	if data.has("on-hand-completion-desc"):
		infoDetail.text += str("[b]On Hand Completion:[/b] ", data["on-hand-completion-desc"], "\n")
	if data.has("on-fail-desc"):
		infoDetail.text += str("[b]On Fail:[/b] ", data["on-fail-desc"], "\n")
	
func set_data(pData : Dictionary) -> void:
	data = pData

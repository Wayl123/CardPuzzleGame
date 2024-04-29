extends Panel

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var close = %Close
@onready var menuList = %MenuList
@onready var content = %Content

var drag_position = null
var gameInfoData = {}

func _ready() -> void:
	close.connect("pressed", Callable(self, "_on_close"))
	
	gameInfoData = globalData.get_game_info()
	_create_menu()
	_update_content(gameInfoData[gameInfoData.keys()[0]])

func _process(delta : float) -> void:
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_pressed("LeftMouse"):
		drag_position = get_global_mouse_position() - global_position
	else:
		drag_position = null
		
func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion and drag_position != null:
		set_global_position(get_global_mouse_position() - drag_position)
	
func _create_menu() -> void:
	for infoSection in gameInfoData:
		var sectionButton = Button.new()
		sectionButton.set_text(infoSection)
		sectionButton.connect("pressed", Callable(self, "_update_content").bind(gameInfoData[infoSection]))
		menuList.add_child(sectionButton)
		
func _update_content(pText : String) -> void:
	content.set_text(pText)

func _on_close() -> void:
	queue_free()

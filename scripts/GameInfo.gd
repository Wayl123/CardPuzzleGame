extends Panel

@onready var globalData = get_tree().get_first_node_in_group("GlobalData")
@onready var close = %Close
@onready var menuList = %MenuList
@onready var content = %Content

var drag_position = null
var gameInfoData = {}

func _ready() -> void:
	close.connect("pressed", Callable(self, "_on_close"))
	content.connect("meta_clicked", Callable(self, "_on_button_select"))
	
	gameInfoData = globalData.get_game_info()
	_create_menu()
	_on_button_select(gameInfoData.keys()[0])

func _process(delta : float) -> void:
	if Rect2(Vector2(), size).has_point(get_local_mouse_position()) and Input.is_action_pressed("LeftMouse"):
		drag_position = get_global_mouse_position() - global_position
	else:
		drag_position = null
		
func _input(event : InputEvent) -> void:
	if event is InputEventMouseMotion and drag_position != null:
		set_global_position(get_global_mouse_position() - drag_position)
	
func _create_menu() -> void:
	var pressedStyleBox = StyleBoxFlat.new()
	pressedStyleBox.set_bg_color(Color(0.75, 0.75, 0.75, 0.5))
	
	for infoSection in gameInfoData:
		var sectionButton = Button.new()
		sectionButton.set_name(infoSection)
		sectionButton.set_text(infoSection)
		sectionButton.set("theme_override_styles/pressed", pressedStyleBox)
		sectionButton.set("theme_override_styles/focus", StyleBoxEmpty.new())
		sectionButton.set_toggle_mode(true)
		sectionButton.connect("pressed", Callable(self, "_update_content").bind(gameInfoData[infoSection]))
		menuList.add_child(sectionButton)
		
func _update_content(pText : String) -> void:
	for menuButtons in menuList.get_children():
		if not menuButtons.has_focus():
			menuButtons.set_pressed(false)
	content.set_text(pText)
	
func _on_button_select(arguement : Variant) -> void:
	var selectedButton = menuList.get_node(arguement)
	
	selectedButton.grab_focus()
	selectedButton.set_pressed(true)
	selectedButton.emit_signal("pressed")

func _on_close() -> void:
	queue_free()

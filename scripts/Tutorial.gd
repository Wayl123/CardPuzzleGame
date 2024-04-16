extends Node2D

@onready var tutorialMap = get_tree().get_first_node_in_group("TutorialMap")
@onready var dialog = %Dialog

var CONFIRMATIONBOX = preload("res://scene/confirmation_box.tscn")
var TUTORIALPOINTER = preload("res://scene/tutorial_pointer.tscn")
var TUTORIALBLOCKER = preload("res://scene/tutorial_blocker.tscn")

var progress = 0
var tutorialListPath = "res://scripts/TutorialDialog.json"
var tutorialData = {}
var currentDialog = {}

func _ready():
	dialog.connect("confirmed", Callable(self, "_set_current_dialog"))
	dialog.connect("canceled", Callable(self, "_show_close_dialog"))
	
	tutorialData = _load_json_file(tutorialListPath)
	
	_set_current_dialog()
	
func _load_json_file(filePath : String) -> Dictionary:
	if FileAccess.file_exists(filePath):
		var dataFile = FileAccess.open(filePath, FileAccess.READ)
		var parsedResult = JSON.parse_string(dataFile.get_as_text())
		
		if parsedResult is Dictionary:
			return parsedResult
		else:
			print("Error reading file")
	else:
		print("File doesn't exist")
		
	return {}
	
func _set_current_dialog():
	progress += 1
	currentDialog = tutorialData[str(progress)]
	
	_remove_blocker()
	_remove_pointers()
	dialog.get_ok_button().set_visible(true)
	dialog.set_text("")
	dialog.reset_size()
	
	match currentDialog["type"]:
		"normal":
			_place_blocker()
		"pointer":
			_place_blocker()
			_place_pointer(false)
		"action":
			dialog.get_ok_button().set_visible(false)
			_place_pointer(true)
	_show_dialog()
	if currentDialog.has("wait-for-exit"):
		await tutorialMap.get_node(currentDialog["wait-for-exit"]).tree_exited
		_set_current_dialog()
			
func _show_dialog():
	for child in dialog.get_children():
		dialog.remove_child(child)
		child.queue_free()
	dialog.set_text(currentDialog["text"])
	dialog.set_title(str("Tutorial: ", progress, "/", tutorialData.size()))
	dialog.popup_centered()
	dialog.set_visible(true)
	
func _place_blocker():
	var blocker = TUTORIALBLOCKER.instantiate()
	tutorialMap.get_node("CanvasLayer").add_child(blocker)
	
func _place_pointer(pAction : bool):
	for pointer in currentDialog["pointers"]:
		var pointerBox = TUTORIALPOINTER.instantiate()
		tutorialMap.get_node(pointer).add_child(pointerBox)
		if pAction:
			pointerBox.connect("pressed", Callable(self, "_set_current_dialog"))
	
func _show_close_dialog():
	var confirmationBox = CONFIRMATIONBOX.instantiate()
	confirmationBox.set_title("Close Tutorial?")
	confirmationBox.set_text("Do you want to skip the tutorial?")
	dialog.add_child(confirmationBox)
	confirmationBox.popup_centered()
	confirmationBox.set_visible(true)
	confirmationBox.connect("confirmed", Callable(self, "_end_tutorial"))
	confirmationBox.connect("canceled", Callable(self, "_show_dialog"))
	
func _remove_blocker():
	for blocker in get_tree().get_nodes_in_group("TutorialBlocker"):
		blocker.queue_free()
	
func _remove_pointers():
	for pointer in get_tree().get_nodes_in_group("TutorialPointer"):
		pointer.queue_free()
	
func _end_tutorial():
	_remove_blocker()
	_remove_pointers()
	queue_free()
	
func get_progress() -> int:
	return progress

extends Node2D

@onready var dialog = %Dialog

var CONFIRMATIONBOX = preload("res://scene/confirmation_box.tscn")

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
	match currentDialog["type"]:
		"normal":
			_show_dialog()
		"pointer":
			pass
		"action":
			pass
			
func _show_dialog():
	for child in dialog.get_children():
		dialog.remove_child(child)
		child.queue_free()
	dialog.set_text(currentDialog["text"])
	dialog.set_title(str("Tutorial: ", progress, "/", tutorialData.size()))
	dialog.popup_centered()
	dialog.set_visible(true)
	
func _show_close_dialog():
	var confirmationBox = CONFIRMATIONBOX.instantiate()
	confirmationBox.set_title("Close Tutorial?")
	confirmationBox.set_text("Do you want to skip the tutorial?")
	dialog.add_child(confirmationBox)
	confirmationBox.popup_centered()
	confirmationBox.set_visible(true)
	confirmationBox.connect("confirmed", Callable(self, "_end_tutorial"))
	confirmationBox.connect("canceled", Callable(self, "_show_dialog"))
	
func _end_tutorial():
	queue_free()

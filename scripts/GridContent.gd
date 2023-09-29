extends TextureButton

var DRAGPREVIEW = preload("res://scene/drag_preview.tscn")

func _ready():
	pass

func _get_drag_data(_pos):
	var data = {}
	
	if (!disabled && texture_normal):
		data["origin_node"] = self
		data["origin_texture_normal"] = texture_normal
		
		var dragPreview = DRAGPREVIEW.instantiate()
		dragPreview.set_texture(texture_normal)
		add_child(dragPreview)
	
	return data
	
func _can_drop_data(_pos, data):
	if (!disabled):
		return true
	return false
	
func _drop_data(_pos, data):
	if (data):
		data["origin_node"].texture_normal = texture_normal
		
		texture_normal = data["origin_texture_normal"]

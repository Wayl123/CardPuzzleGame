extends Node2D

func _ready() -> void:
	_set_transform()

func _set_transform() -> void:
	var localTransform = Transform2D(Vector2(0.6, -0.2), Vector2(0, 0.55), Vector2(2, 3))
	
	set_transform(localTransform)

func set_transform_scale(value : float) -> void:
	set_transform(get_transform() * value)

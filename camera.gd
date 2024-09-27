extends Camera2D

@export_group("Component")
@export var _bird: Bird

func _process(_delta: float) -> void:
	global_position = Vector2(_bird.global_position.x, 0)

extends Camera2D

@export_group("Component")
@export var _bird: Bird

func _process(_delta: float) -> void:
	global_position.x = _bird.global_position.x

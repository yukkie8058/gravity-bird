@tool
class_name Pipe
extends Node2D

@export var upper_offset: float:
	set(v): upper_offset = v; queue_redraw()
@export var lower_offset: float:
	set(v): lower_offset = v; queue_redraw()
@export var texture_top: Texture2D:
	set(v): texture_top = v; queue_redraw()
@export var texture_middle: Texture2D:
	set(v): texture_middle = v; queue_redraw()
var index: int = -1

var _part_upper: PipePart = PipePart.new()
var _part_lower: PipePart = PipePart.new()

func get_global_rect() -> Rect2:
	var width := maxf(texture_top.get_width(), texture_middle.get_width())
	var size_half := Vector2(width / 2, _get_viewport_size().y / 2)
	return Rect2(to_global(-size_half), to_global(size_half))

func _init() -> void:
	add_child(_part_upper, false, Node.INTERNAL_MODE_FRONT)
	_part_upper.rotation = TAU / 2
	
	add_child(_part_lower, false, Node.INTERNAL_MODE_FRONT)

func _draw() -> void:
	for part: PipePart in [_part_upper, _part_lower]:
		part.texture_top = texture_top
		part.texture_middle = texture_middle
	
	_part_upper.position.y = -_get_viewport_size().y / 2
	_part_upper.height = upper_offset - _part_upper.position.y
	
	_part_lower.position.y = _get_viewport_size().y / 2
	_part_lower.height = _part_lower.position.y - lower_offset

func _get_viewport_size() -> Vector2:
	return Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height"),
	) if Engine.is_editor_hint() else get_viewport_rect().size

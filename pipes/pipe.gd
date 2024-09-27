@tool
class_name Pipe
extends StaticBody2D

@export var upper_y: float:
	set(v): upper_y = v; queue_redraw()
@export var lower_y: float:
	set(v): lower_y = v; queue_redraw()
@export var texture_top: Texture2D:
	set(v): texture_top = v; queue_redraw()
@export var texture_middle: Texture2D:
	set(v): texture_middle = v; queue_redraw()
var index: int = -1

var _shape_upper: RectangleShape2D = RectangleShape2D.new()
var _shape_upper_owner: int
var _shape_lower: RectangleShape2D = RectangleShape2D.new()
var _shape_lower_owner: int

func get_global_rect() -> Rect2:
	var width := maxf(texture_top.get_width(), texture_middle.get_width())
	var size_half := Vector2(width / 2, _get_viewport_size().y / 2)
	return Rect2(to_global(-size_half), to_global(size_half))

func _init() -> void:
	_shape_upper_owner = create_shape_owner(Object.new())
	shape_owner_add_shape(_shape_upper_owner, _shape_upper)
	_shape_lower_owner = create_shape_owner(Object.new())
	shape_owner_add_shape(_shape_lower_owner, _shape_lower)

func _draw() -> void:
	var upper_edge_y := _get_viewport_size().y / 2 - -upper_y - texture_top.get_height()
	draw_set_transform(Vector2(0, upper_y), TAU / 2)
	draw_texture(texture_top, Vector2(-texture_top.get_width() / 2.0, 0))
	draw_texture_rect(texture_middle, Rect2(
		Vector2(-texture_middle.get_width() / 2.0, texture_top.get_height()),
		Vector2(texture_middle.get_width(), upper_edge_y)
	), true)
	
	var upper_length_y := absf(upper_edge_y - upper_y)
	shape_owner_set_transform(_shape_upper_owner, Transform2D(0, Vector2(0, -upper_length_y / 2 + upper_y)))
	_shape_upper.size = Vector2(texture_top.get_width(), upper_length_y)
	
	var lower_edge_y := _get_viewport_size().y / 2 - lower_y - texture_top.get_height()
	draw_set_transform(Vector2(0, lower_y))
	draw_texture(texture_top, Vector2(-texture_top.get_width() / 2.0, 0))
	draw_texture_rect(texture_middle, Rect2(
		Vector2(-texture_middle.get_width() / 2.0, texture_top.get_height()),
		Vector2(texture_middle.get_width(), lower_edge_y)
	), true)
	
	var lower_length_y := absf(lower_edge_y - lower_y)
	shape_owner_set_transform(_shape_lower_owner, Transform2D(0, Vector2(0, lower_length_y / 2 + lower_y)))
	_shape_lower.size = Vector2(texture_top.get_width(), lower_length_y)

func _get_viewport_size() -> Vector2:
	return Vector2(
		ProjectSettings.get_setting("display/window/size/viewport_width"),
		ProjectSettings.get_setting("display/window/size/viewport_height")
	) if Engine.is_editor_hint() else get_viewport_rect().size


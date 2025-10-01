@tool
class_name PipePart
extends StaticBody2D

@export var height: float:
	set(v): height = v; queue_redraw()
@export var texture_top: Texture2D:
	set(v): assert(v != null); texture_top = v; queue_redraw()
@export var texture_middle: Texture2D:
	set(v): assert(v != null); texture_middle = v; queue_redraw()

var _shape: RectangleShape2D = RectangleShape2D.new()
var _shape_owner: int = -1

func _init() -> void:
	_shape_owner = create_shape_owner(self)
	shape_owner_add_shape(_shape_owner, _shape)

func _draw() -> void:
	draw_texture(texture_top, Vector2(-_get_width()/2, -height))
	draw_texture_rect(texture_middle, Rect2(
		-_get_width()/2, -height + texture_top.get_height(),
		texture_middle.get_width(), maxf(0, height - texture_top.get_height()),
	), true)
	
	shape_owner_set_transform(_shape_owner, Transform2D(0, Vector2(0, -height/2)))
	_shape.size = Vector2(_get_width(), height)
	
	if get_tree().debug_collisions_hint or Engine.is_editor_hint():
		var color := ProjectSettings.get_setting("debug/shapes/collision/shape_color")
		draw_set_transform_matrix(shape_owner_get_transform(_shape_owner))
		_shape.draw(get_canvas_item(), color)

func _get_width() -> float:
	assert(texture_top.get_width() == texture_middle.get_width())
	return texture_top.get_width()

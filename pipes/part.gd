@tool
class_name PipePart
extends StaticBody2D

@export var height: float:
	set(v): height = v; queue_redraw()
@export var texture_top: Texture2D:
	set(v): assert(v != null); texture_top = v; queue_redraw()
@export var texture_middle: Texture2D:
	set(v): assert(v != null); texture_middle = v; queue_redraw()

var _base: CollisionShape2D = CollisionShape2D.new()
var _top: CollisionShape2D = CollisionShape2D.new()
var _corner_left: CollisionShape2D = CollisionShape2D.new()
var _corner_right: CollisionShape2D = CollisionShape2D.new()

func _init() -> void:
	_base.shape = RectangleShape2D.new()
	add_child(_base, false, INTERNAL_MODE_BACK)
	_top.shape = RectangleShape2D.new()
	add_child(_top, false, INTERNAL_MODE_BACK)

	var corner_shape := CircleShape2D.new()
	corner_shape.radius = 14
	_corner_left.shape = corner_shape
	add_child(_corner_left, false, INTERNAL_MODE_BACK)
	_corner_right.shape = corner_shape
	add_child(_corner_right, false, INTERNAL_MODE_BACK)

func _draw() -> void:
	assert(texture_top.get_width() == texture_middle.get_width())
	var width := texture_top.get_width()

	draw_texture(texture_top, Vector2(-width/2, -height))
	draw_texture_rect(texture_middle, Rect2(
		-width/2, -height + texture_top.get_height(),
		texture_middle.get_width(), maxf(0, height - texture_top.get_height()),
	), true)

	#region Collision shapes
	var corner_radius := (_corner_left.shape as CircleShape2D).radius

	_base.set_deferred("disabled", height <= corner_radius)
	if height > corner_radius:
		_base.position.y = (-height + corner_radius) / 2
		(_base.shape as RectangleShape2D).size = Vector2(width, height - corner_radius)
	_top.position.y = -height + corner_radius/2
	(_top.shape as RectangleShape2D).size = Vector2(width - corner_radius*2, corner_radius)

	var corner_y := -height + corner_radius
	_corner_left.position = Vector2(-width/2 + corner_radius, corner_y)
	_corner_right.position = Vector2(width/2 - corner_radius, corner_y)
	#endregion

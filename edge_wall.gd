@tool
class_name EdgeWall
extends StaticBody2D

var _shape_top: WorldBoundaryShape2D
var _shape_bottom: WorldBoundaryShape2D

func _init() -> void:
	var owner_id := create_shape_owner(Object.new())
	
	_shape_top = WorldBoundaryShape2D.new()
	_shape_top.normal = Vector2.DOWN
	shape_owner_add_shape(owner_id, _shape_top)
	
	_shape_bottom = WorldBoundaryShape2D.new()
	_shape_bottom.normal = Vector2.UP
	shape_owner_add_shape(owner_id, _shape_bottom)

func _enter_tree() -> void:
	get_viewport().size_changed.connect(_viewport_size_changed)
	_viewport_size_changed()

func _viewport_size_changed() -> void:
	_shape_top.distance = -get_viewport_rect().size.y / 2
	_shape_bottom.distance = -get_viewport_rect().size.y / 2

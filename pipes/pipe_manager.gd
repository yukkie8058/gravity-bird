class_name PipeManager
extends Node2D

var pipes: Array[Pipe] = []
signal pipe_appended()
var cash_pipes: Array[Pipe] = []

@export var _interval: float = 250
@export var _gap_length: float = 150
@export var _texture_pairs: Dictionary

var _index: int
var _next_texture: int = -1

func _init() -> void:
	_next_texture = randf() * _texture_pairs.size() as int

func _game_state_entered() -> void:
	for i in pipes: i.queue_free()
	pipes.clear()
	_index = 0

func _game_state_processing(_delta: float) -> void:
	var camera_rect := get_viewport_rect() * get_canvas_transform()
	
	var width := maxf(
		(_texture_pairs.keys()[_next_texture] as Texture2D).get_width(),
		(_texture_pairs.values()[_next_texture] as Texture2D).get_width()
	)
	if pipes.is_empty() or pipes[-1].global_position.x < camera_rect.end.x + width - _interval:
		if cash_pipes.is_empty():
			pipes.append(Pipe.new())
		else:
			pipes.append(cash_pipes.pop_front())
		pipes[-1].index = _index
		_index += 1
		pipes[-1].global_position = Vector2(camera_rect.end.x + width / 2, 0)
		pipes[-1].upper_y = randf_range(-get_viewport_rect().size.y / 2, get_viewport_rect().size.y / 2 - _gap_length)
		pipes[-1].lower_y = pipes[-1].upper_y + _gap_length
		pipes[-1].texture_top = _texture_pairs.keys()[_next_texture]
		pipes[-1].texture_middle = _texture_pairs.values()[_next_texture]
		add_child(pipes[-1])
		pipe_appended.emit()
	
	if pipes.size() > 1 and not pipes[0].get_global_rect().intersects(camera_rect):
		assert(cash_pipes.size() < 4)
		remove_child(pipes[0])
		cash_pipes.append(pipes.pop_front())
		if cash_pipes.size() > 4:
			cash_pipes.pop_front().queue_free()
	
	_next_texture = randf() * _texture_pairs.size() as int

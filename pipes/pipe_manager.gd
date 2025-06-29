class_name PipeManager
extends Node2D

var pipes: Array[Pipe] = []
signal pipe_appended()

@export var _interval: float = 250
@export var _gap_length: float = 150
@export var _texture_pairs: Dictionary

var _index: int
var _next_texture: int = -1

func _init() -> void:
	_next_texture = randf() * _texture_pairs.size() as int

func _idle_state_entered() -> void:
	_pipes_clear()

func _game_state_entered() -> void:
	_pipes_clear()

func _game_state_processing(_delta: float) -> void:
	var camera_rect := get_viewport_rect() * get_canvas_transform()
	
	var width := maxf(
		(_texture_pairs.keys()[_next_texture] as Texture2D).get_width(),
		(_texture_pairs.values()[_next_texture] as Texture2D).get_width()
	)
	if pipes.is_empty() or pipes[-1].global_position.x < camera_rect.end.x + width - _interval:
		pipes.append(Pipe.new())
		pipes[-1].index = _index
		_index += 1
		pipes[-1].global_position = Vector2(camera_rect.end.x + width / 2, 0)
		pipes[-1].upper_y = randf_range(
			-get_viewport_rect().size.y / 2,
			get_viewport_rect().size.y / 2 - _gap_length,
		)
		pipes[-1].lower_y = pipes[-1].upper_y + _gap_length
		pipes[-1].texture_top = _texture_pairs.keys()[_next_texture]
		pipes[-1].texture_middle = _texture_pairs.values()[_next_texture]
		add_child(pipes[-1])
		pipe_appended.emit()
	
	if pipes.size() > 1 and not pipes[0].get_global_rect().intersects(camera_rect):
		(pipes.pop_front() as Pipe).queue_free()
	
	_next_texture = randf() * _texture_pairs.size() as int

func _pipes_clear() -> void:
	for pipe in pipes: pipe.queue_free()
	pipes.clear()
	_index = 0

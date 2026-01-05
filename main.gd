class_name Main
extends Node

static var _instance: Main
static func node() -> Main: return _instance

var score: int:
	set(v): score = v; _score_changed()
signal score_changed()

var _is_high_score: bool
func is_high_score() -> bool: return _is_high_score

func _init() -> void:
	if _instance != null:
		push_error("Mainは複数存在できません")
		return
	_instance = self

func _score_changed() -> void:
	_is_high_score = score > Save.get_singleton().high_score
	score_changed.emit()

func _idle_state_entered() -> void:
	score = 0

func _game_over_state_entered() -> void:
	if _is_high_score:
		Save.get_singleton().high_score = score

class_name Main
extends Node

static var _instance: Main
static func node() -> Main: return _instance

var score: int:
	set(v): score = v; score_changed.emit()
signal score_changed()

func _init() -> void:
	if _instance != null:
		push_error("Mainは複数存在できません")
		return
	_instance = self

func _idle_state_entered() -> void:
	score = 0

func _game_over_state_entered() -> void:
	var save := Save.get_singleton()
	if score > save.high_score:
		save.high_score = score

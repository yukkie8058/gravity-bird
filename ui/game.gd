extends Control

@export_group("Component")
@export var _score: Label

func _enter_tree() -> void:
	Main.node().score_changed.connect(_main_score_changed)
	_main_score_changed()

func _main_score_changed() -> void:
	_score.text = str(Main.node().score)


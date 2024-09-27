extends Control

@export_group("Component")
@export var _instruction: Label

func _enter_tree() -> void:
	_instruction.visible = false

func _instruction_timer_timeout() -> void:
	_instruction.visible = not _instruction.visible


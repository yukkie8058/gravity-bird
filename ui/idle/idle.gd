extends MarginContainer

@export_group("Component")
@export var _instruction: Label

func _enter_tree() -> void:
	_instruction.visible = false
	
	var mobile := ["mobile", "web_android", "web_ios"].any(OS.has_feature)
	_instruction.text = "" if mobile else "PRESS SPACE\nOR\n"
	_instruction.text += "%s ANYWHERE" % ("TOUCH" if mobile else "CLICK")

func _instruction_timer_timeout() -> void:
	_instruction.visible = not _instruction.visible
